//
//  HomeMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct HomeMainView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    @State var userHasPreviouslyWatchedLectures: Bool = true
    
    @State private var selectedTab = 0
    
    let tabs = ["For You", "Computer Science", "Business", "Science", "Humanities", "Engineering", "Healthcare"]
    
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
                                        .animation(.easeInOut(duration: 0.4), value: selectedTab) // Animate text color
                                    
                                    // Blue line indicator for selected tab
                                    Rectangle()
                                        .fill(selectedTab == index ? Color.orange : Color.clear)
                                        .frame(height: 2)
                                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: selectedTab) // Animate underline
                                }
                                .onTapGesture {
                                    selectedTab = index
                                }
                                .padding(.trailing, 2)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    switch selectedTab {
                    case 0:
                        Trending()
                    case 1:
                        ComputerScience()
                    case 2:
                        Trending()
                    case 3:
                        ComputerScience()
                    case 4:
                        Trending()
                    case 5:
                        ComputerScience()
                    case 6:
                        Trending()
                    default:
                        Text("Couldn't load tab")
                    }
                    
                    Spacer()
                    
                   BottomBrandView()
                }
                
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
            .onAppear {
                // for first time loading this view, fetch the content
                if homeController.curatedCourses.isEmpty {
                    homeController.isCommunityFavoritesLoading = true
                    homeController.isCuratedCoursesLoading = true
                    homeController.isUniversityLoading = true
                    homeController.retrieveLeadingUniversities(courseController: courseController)
                    homeController.retrieveCuratedCourses(courseController: courseController)
                    homeController.retrieveCommunityFavorites(courseController: courseController)
                }
                
                
                
                courseController.focusedLectureStack = []
                courseController.focusedCourseStack = []
            }
        }
        // Needed for iPad compliance
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeMainView()
        .environmentObject(HomeController())
}
