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
    
    // YouTube Player Controller
    // we initalize it here because we want to change source url when we foucs a new lecture, which happens in this view sometimes. sometimes also happens in lecture view, but this is a parent of lecture view
    // Youtube player
    @StateObject var youTubePlayerController = YouTubePlayerController()
    
    @State var userHasPreviouslyWatchedLectures: Bool = true
    
    @State private var selectedTab = 0
        
    let tabs = ["Trending", "Computer Science", "Mathmatics", "Humanities", "Psychology"]
    
    var body: some View {
        NavigationView {
            VStack {
                TopBrandView()
                
                ScrollView(showsIndicators: false) {
                    // Top Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(tabs.enumerated()), id: \.element) { index, tab in
                                VStack {
                                    Text(tab)
                                        .foregroundColor(selectedTab == index ? .orange : .gray)
                                        .font(.system(size: 11, design: .serif))
                                        .bold()
                                        .lineLimit(1)                    // Ensure single line
                                        .truncationMode(.tail)           // Add ellipsis if text is too long
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    // Blue line indicator for selected tab
                                    Rectangle()
                                        .fill(selectedTab == index ? Color.orange : Color.clear)
                                        .frame(height: 2)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = index
                                    }
                                }
                                .padding(.trailing, 2)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    
                    // Resume Watching
                    // If the user has previously watched some lectures, show what they've watched, limit to 5, and add a View All button.
//                    if (self.userHasPreviouslyWatchedLectures) {
//                        ContinueLearningCourseList()
//                            .padding(.top, 5)
//                    }
                    
                    // the loading view
                    if homeController.isUniversityLoading || homeController.isCuratedCoursesLoading || homeController.isCommunityFavoritesLoading {
                        HomeLoadingView()
                    } else {
//                        Categories()
//                            .padding(.top, 10)
                        Collections()
                            .padding(.top, 5)
                        
                        
                        CuratedCourses()
                            .padding(.top, 10)
                        
                        // Otherwise the content is all loaded and ready to go
                        LeadingUniversities()
                            .padding(.top, 10)
                        
                        CommunityFavorites()
                            .padding(.top, 10)
                    }
                    
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
        .environmentObject(youTubePlayerController)
    }
}

#Preview {
    HomeMainView()
        .environmentObject(HomeController())
}
