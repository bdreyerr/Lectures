//
//  CourseHistory.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct CourseHistory: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    
    
    // list local to the view so navigation won't abrutpy change when the list on the controller is updated
    @State var localWatchHistories: [WatchHistory] = []
    var body: some View {
        Group {
            // Coure History (preview)
            HStack {
                Image(systemName: "play.circle")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Course History")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            .padding(.top, 10)
            
            
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
            
            HStack {
                NavigationLink(destination: FullCourseHistory()) {
                    Text("View All")
                        .font(.system(size: 10))
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                self.localWatchHistories = myCourseController.watchHistories
            }
        }
    }
}

#Preview {
    CourseHistory()
}
