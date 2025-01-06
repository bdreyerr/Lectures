//
//  HomeMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct HomeMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeController: HomeController
    
    @State var userHasPreviouslyWatchedLectures: Bool = true
    
    
    var body: some View {
        NavigationView {
            VStack {
                TopBrandView()
                
                ScrollView(showsIndicators: false) {
                    // Resume Watching
                    // If the user has previously watched some lectures, show what they've watched, limit to 5, and add a View All button.
                    if (self.userHasPreviouslyWatchedLectures) {
                        ContinueLearningCourseList()
                            .padding(.top, 5)
                    }
                    
                    // Leading Universities (verified)
                    LeadingUniversities()
                        .padding(.top, 10)
                    
                    // Category Pills
                    // Filter the course in the sections below towards certain categories
                    Categories()
                        .padding(.top, 10)
                    
                    // Curated Courses (verified)
                    // Courses verified by the app with official AI features
                    CuratedCourses()
                        .padding(.top, 10)
                    
                    // Community Favorites
                    // Courses liked a lot by the community
                    CommunityFavorites()
                        .padding(.top, 10)
                    
                    // Logo
                    
                    Spacer()
                    
                    // Logo
                    if (colorScheme == .light) {
                        Image("LogoTransparentWhiteBackground")
                            .resizable()
                            .frame(width: 80, height: 80)
                    } else if (colorScheme == .dark) {
                        Image("LogoBlackBackground")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Text("Lectura")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .opacity(0.8)
                    Text("version 1.1")
                        .font(.system(size: 11, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .opacity(0.8)
                }
                
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HomeMainView()
        .environmentObject(HomeController())
}
