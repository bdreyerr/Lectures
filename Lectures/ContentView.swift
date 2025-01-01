//
//  ContentView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: CustomTabBar.TabItemKind = .home
    
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
    @StateObject var authController = AuthController()
    @StateObject var userController = UserController()
    @StateObject var homeController = HomeController()
    
    var body: some View {
        ZStack {
            if hasUserSeenPaywall {
                switch selectedTab {
                case .home:
                    HomeMainView()
                case .trends:
                    MyCoursesMainView()
//                    Paywall()
                case .search:
                    SearchMainView()
                case .settings:
                    SettingsMainView()
                }
                
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            } else {
                Paywall()
            }
        }
        .environmentObject(authController)
        .environmentObject(userController)
        .environmentObject(homeController)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthController())
        .environmentObject(UserController())
        .environmentObject(HomeController())
}
