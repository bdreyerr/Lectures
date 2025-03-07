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
    
    let tabs = ["For You", "Computer Science", "Business", "Engineering", "Humanities", "Math", "Health"]
    
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
                                        .foregroundColor(selectedTab == index ? .blue : .gray)
                                        .font(.system(size: 11, design: .serif))
                                        .bold()
                                        .lineLimit(1)                    // Ensure single line
                                        .truncationMode(.tail)           // Add ellipsis if text is too long
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .animation(.easeInOut(duration: 0.4), value: selectedTab) // Animate text color
                                    
                                    // Blue line indicator for selected tab
                                    Rectangle()
                                        .fill(selectedTab == index ? Color.blue : Color.clear)
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
                        TabMainView(tabName: tabs[selectedTab])
                    case 2:
                        TabMainView(tabName: tabs[selectedTab])
                    case 3:
                        TabMainView(tabName: tabs[selectedTab])
                    case 4:
                        TabMainView(tabName: tabs[selectedTab])
                    case 5:
                        TabMainView(tabName: tabs[selectedTab])
                    case 6:
                        TabMainView(tabName: tabs[selectedTab])
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
