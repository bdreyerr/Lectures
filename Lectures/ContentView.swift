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
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    // TODO: Decide if we want to keep the paywall hidden at app launch
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = true
    
    @StateObject var courseController = CourseController()
    
    @StateObject var authController = AuthController()
    @StateObject var userController = UserController()
    @StateObject var homeController = HomeController()
    @StateObject var myCourseController = MyCourseController()
    
    // Resource Controllers
    @StateObject var resourceController = ResourceController()
    @StateObject var examController = ExamController()
    @StateObject var examAnswerController = ExamAnswerController()
    @StateObject var notesController = NotesController()
    @StateObject var homeworkController = HomeworkController()
    @StateObject var homeworkAnswersController = HomeworkAnswersController()
    
    // Rate Limiter
    @StateObject var rateLimiter = RateLimiter()
    
    // Created on December 15, 2024 - Main view controller managing tab bar navigation,
    // user authentication, course management, and various resource controllers
    
    // subscriptions
    @StateObject private var subscriptionController = SubscriptionController.shared
    
    var body: some View {
        ZStack {
            
            
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
            
            // show rate limit popup if applicable
            if rateLimiter.shouldRateLimitPopupShow {
                RateLimitPopUp()
            }
            
            VStack {
                Spacer()
                if tabbarController.isTabbarShowing {
                    CustomTabBar(selectedTab: $selectedTab)
                }
                
            }
        }
        .environmentObject(tabbarController)
        .environmentObject(authController)
        .environmentObject(userController)
        .environmentObject(homeController)
        .environmentObject(resourceController)
        .environmentObject(examController)
        .environmentObject(examAnswerController)
        .environmentObject(notesController)
        .environmentObject(homeworkController)
        .environmentObject(homeworkAnswersController)
        .environmentObject(myCourseController)
        .environmentObject(courseController)
        .environmentObject(rateLimiter)
        .environmentObject(subscriptionController)
        .onChange(of: isSignedIn) {
            if isSignedIn == true {
                if let user = Auth.auth().currentUser {
                    userController.retrieveUserFromFirestore(userId: user.uid)
                    
                    // Sign in the user into RevenueCat
//                    subscriptionController.loginRevenueCat(userId: user.uid)
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
        .environmentObject(MyCourseController())
        .environmentObject(CourseController())
        .environmentObject(ResourceController())
        .environmentObject(RateLimiter())
}
