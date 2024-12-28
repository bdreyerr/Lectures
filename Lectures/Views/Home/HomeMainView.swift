//
//  HomeMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct HomeMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var userHasPreviouslyWatchedLectures: Bool = true
    
    
    var body: some View {
        NavigationView {
            VStack {
                // Today's Prompt and Change Date Button
                HStack {
                    if (colorScheme == .light) {
                        Image("LogoTransparentWhiteBackground")
                            .resizable()
                            .frame(width: 30, height: 30)
                    } else if (colorScheme == .dark) {
                        Image("LogoBlackBackground")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("|   Lectura")
                        .font(.system(size: 16, design: .serif))
                        .bold()
                    
                    Spacer()
                    
                    Text(Date().formatted(.dateTime.month().day()))
                        .font(.system(size: 14, design: .serif))
                }
                
                ScrollView(showsIndicators: false) {
                    // Resume Watching
                    // If the user has previously watched some lectures, show what they've watched, limit to 5, and add a View All button.
                    if (self.userHasPreviouslyWatchedLectures) {
                        ContinueLearningCourseList()
                            .padding(.top, 5)
                    }
                    
                    
                    // Search Box
                    // Search any lecture, when you tap on the search bar it kind of expands into it's own view
                    //                        HomeSearch()
                    //                            .padding(.top, 20)
                    //                        .padding(.horizontal, 10)
                    
                    
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
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    HomeMainView()
}
