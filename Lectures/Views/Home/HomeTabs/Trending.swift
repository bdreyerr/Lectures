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
    var body: some View {
        Group {
            // the loading view
            if homeController.isUniversityLoading || homeController.isCuratedCoursesLoading || homeController.isCommunityFavoritesLoading {
                HomeLoadingView()
            } else {
                //                        Categories()
                //                            .padding(.top, 10)
                //            CollectionsTrending()
                //                .padding(.top, 10)
                
                
                // If the user is pro, display the courses they have watched latest
                if subscriptionController.isPro {
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
                        
                        if !myCourseController.watchHistories.isEmpty {
                            Group {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(localWatchHistories, id: \.id) { watchHistory in
                                            if let watchHistoryCourseId = watchHistory.courseId {
                                                if let course = courseController.cachedCourses[watchHistoryCourseId] {
                                                    NavigationLink(destination: CourseView()) {
                                                        WatchedCourseCard(course: course, watchHistory: watchHistory)
                                                    }
                                                    .simultaneousGesture(TapGesture().onEnded { _ in
                                                        courseController.focusCourse(course)
                                                    })
                                                } else {
                                                    SkeletonLoader(width: 400 * 0.6, height: 150)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                self.localWatchHistories = myCourseController.watchHistories
                            }
                        }
                        
                    }
                    .onAppear {
                        if let user = Auth.auth().currentUser {
                            if myCourseController.watchHistories.isEmpty {
                                myCourseController.retrieveRecentWatchHistories(userId: user.uid, courseController: courseController)
                            }
                        }
                    }
                }
                
                
                CuratedCourses()
                    .padding(.top, 10)
                
                // Otherwise the content is all loaded and ready to go
                LeadingUniversities()
                    .padding(.top, 10)
                
                CommunityFavorites()
                    .padding(.top, 10)
            }
        }
    }
}

#Preview {
    Trending()
}
