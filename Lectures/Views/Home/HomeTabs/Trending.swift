//
//  Trending.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/12/25.
//

import FirebaseAuth
import SwiftUI

struct Trending: View {
    @EnvironmentObject var homeController: HomeController
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    
    // list local to the view so navigation won't abrutpy change when the list on the controller is updated
    @State var localWatchHistories: [WatchHistory] = []
    
    // Add a state variable to track if this tab is active
    @State private var isViewActive = false
    
    var body: some View {
        Group {
            if homeController.isUniversityLoading || homeController.isCuratedCoursesLoading || homeController.isCommunityFavoritesLoading {
                HomeLoadingView()
            } else {
                TrendingContent(localWatchHistories: $localWatchHistories, isViewActive: $isViewActive)
            }
        }
        .onAppear {
            isViewActive = true
        }
        .onDisappear {
            isViewActive = false
        }
    }
}

// Create a new view to handle the content
private struct TrendingContent: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    @EnvironmentObject var subscriptionController: SubscriptionController
    @Binding var localWatchHistories: [WatchHistory]
    @Binding var isViewActive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if subscriptionController.isPro {
                ContinueWatchingSection(localWatchHistories: $localWatchHistories, isViewActive: $isViewActive)
            }
            
            CuratedCourses()
                .padding(.top, 10)
            
            LeadingUniversities()
                .padding(.top, 10)
            
            CommunityFavorites()
                .padding(.top, 10)
        }
    }
}

// Break out the Continue Watching section into its own view
private struct ContinueWatchingSection: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    @EnvironmentObject var subscriptionController: SubscriptionController
    @Binding var localWatchHistories: [WatchHistory]
    @Binding var isViewActive: Bool
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "play.circle")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Continue Watching")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            .padding(.top, 10)
            .padding(.bottom, 6)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(localWatchHistories, id: \.id) { watchHistory in
                        WatchHistoryItem(watchHistory: watchHistory)
                    }
                }
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                if localWatchHistories.isEmpty {
                    if !myCourseController.watchHistories.isEmpty {
                        self.localWatchHistories = myCourseController.watchHistories
                    } else {
                        myCourseController.retrieveRecentWatchHistories(userId: user.uid, courseController: courseController)
                    }
                }
            }
        }
        .onChange(of: myCourseController.watchHistories) {
            if isViewActive {
                self.localWatchHistories = myCourseController.watchHistories
            }
        }
    }
}

// Break out the individual watch history item into its own view
private struct WatchHistoryItem: View {
    @EnvironmentObject var courseController: CourseController
    let watchHistory: WatchHistory
    
    var body: some View {
        Group {
            if let watchHistoryCourseId = watchHistory.courseId,
               let course = courseController.cachedCourses[watchHistoryCourseId],
               let lectureId = watchHistory.lectureId,
               let lectureNumberInCourse = watchHistory.lectureNumberInCourse {
                
                NavigationLink(destination: NewCourse(course: course,
                                                    isLecturePlaying: true,
                                                    lastWatchedLectureId: lectureId,
                                                    lastWatchedLectureNumber: lectureNumberInCourse)) {
                    WatchedCourseCard(course: course, watchHistory: watchHistory)
                }
                .buttonStyle(PlainButtonStyle())
                .simultaneousGesture(TapGesture().onEnded {
                    courseController.focusCourse(course)
                })
            } else {
                SkeletonLoader(width: 400 * 0.6, height: 150)
            }
        }
    }
}

#Preview {
    Trending()
}
