//
//  SavedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct SavedCourses: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    @State private var likedCourseIds: [String] = []
    
    var body: some View {
        Group {
            HStack {
                Image(systemName: "mail.stack")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Saved Courses")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(likedCourseIds, id: \.self) { courseId in
                        if let course = courseController.cachedCourses[courseId] {                            
                            if let watchHistory = myCourseController.cachedWatchHistories[courseId], let lectureNumberInCourse = watchHistory.lectureNumberInCourse, let lectureId = watchHistory.lectureId {
                                NavigationLink(destination: NewCourse(course: course, isLecturePlaying: true, lastWatchedLectureId: lectureId, lastWatchedLectureNumber: lectureNumberInCourse)) {
                                    WatchedCourseCard(course: course, watchHistory: watchHistory)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .simultaneousGesture(TapGesture().onEnded {
                                    courseController.focusCourse(course)
                                })
                            } else {
                                NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                                    CourseCardView(course: course)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .simultaneousGesture(TapGesture().onEnded {
                                    courseController.focusCourse(course)
                                })
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if let user = userController.user {
                // Update the state variable when `user` changes
                DispatchQueue.main.async {
                    likedCourseIds = user.likedCourseIds ?? []
                }
            }
        }
    }
}

#Preview {
    SavedCourses()
}
