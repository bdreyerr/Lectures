//
//  FullCourseHistory.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct FullCourseHistory: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    @EnvironmentObject var userController: UserController
    
    // list local to the view so navigation won't abrutpy change when the list on the controller is updated
    @State var localWatchHistories: [WatchHistory] = []
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                HStack {
                    Text("Course History")
                        .font(.system(size: 13, design: .serif))
                        .bold()
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                ForEach(localWatchHistories, id: \.id) { watchHistory in
                    if let watchHistoryCourseId = watchHistory.courseId {
                        if let course = courseController.cachedCourses[watchHistoryCourseId] {
                            if let lectureId = watchHistory.lectureId, let lectureNumberInCourse = watchHistory.lectureNumberInCourse {
                                NavigationLink(destination: NewCourse(course: course, isLecturePlaying: true, lastWatchedLectureId: lectureId, lastWatchedLectureNumber: lectureNumberInCourse)) {
                                    HStack {
                                        WatchedCourseCard(course: course, watchHistory: watchHistory)
                                        Spacer()
                                    }
                                }
                                .simultaneousGesture(TapGesture().onEnded { _ in
                                    courseController.focusCourse(course)
                                })
                            }
                        } else {
                            SkeletonLoader(width: 400 * 0.6, height: 150)
                        }
                    }
                }
                
                
                if !myCourseController.noWatchHistoriesLeftToLoad {
                    Button(action: {
                        // get more watch Histories
                        if let user = userController.user, let id = user.id {
                            myCourseController.getMoreWatchHistories(userId: id, courseController: courseController)
                        }
                    }) {
                        Text("Fetch More")
                            .font(.system(size: 10))
                            .opacity(0.8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 5)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
        .onAppear {
            DispatchQueue.main.async {
                self.localWatchHistories = myCourseController.watchHistories
            }
        }
    }
}

#Preview {
    FullCourseHistory()
}
