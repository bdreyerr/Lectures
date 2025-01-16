//
//  ContentView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/15/24.
//

import FirebaseAuth
import SwiftUI

struct ContentView: View {
    
    // Tab Bar
    @StateObject var tabbarController = TabBarController()
    @State private var selectedTab: CustomTabBar.TabItemKind = .home
    
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
    @StateObject var courseController = CourseController()
    
    @StateObject var authController = AuthController()
    @StateObject var userController = UserController()
    @StateObject var homeController = HomeController()
    @StateObject var watchHistoryController = WatchHistoryController()
    
    // Resource Controllers
    @StateObject var examController = ExamController()
    @StateObject var examAnswerController = ExamAnswerController()
    @StateObject var notesController = NotesController()
    @StateObject var homeworkController = HomeworkController()
    @StateObject var homeworkAnswersController = HomeworkAnswersController()
    
    var body: some View {
        ZStack {
            if hasUserSeenPaywall {
                switch selectedTab {
                case .home:
                    HomeMainView()
                case .trends:
                    MyCoursesMainView()
                case .search:
                    SearchMainView()
                case .settings:
                    SettingsMainView()
                }
                
                VStack {
                    Spacer()
                    if tabbarController.isTabbarShowing {
                        CustomTabBar(selectedTab: $selectedTab)
                    } 
                    
                }
            } else {
                OnboardingPaywallWithFreeTrial()
            }
        }
        .environmentObject(tabbarController)
        .environmentObject(authController)
        .environmentObject(userController)
        .environmentObject(homeController)
        .environmentObject(examController)
        .environmentObject(examAnswerController)
        .environmentObject(notesController)
        .environmentObject(homeworkController)
        .environmentObject(homeworkAnswersController)
        .environmentObject(watchHistoryController)
        .environmentObject(courseController)
        .onChange(of: isSignedIn) {
            if isSignedIn == true {
                if let user = Auth.auth().currentUser {
                    userController.retrieveUserFromFirestore(userId: user.uid)
                } else {
                    print("no auth user yet lol nice try")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TabBarController())
        .environmentObject(AuthController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
        .environmentObject(ExamController())
        .environmentObject(ExamAnswerController())
        .environmentObject(NotesController())
        .environmentObject(HomeworkController())
        .environmentObject(HomeworkAnswersController())
        .environmentObject(WatchHistoryController())
        .environmentObject(CourseController())
}
