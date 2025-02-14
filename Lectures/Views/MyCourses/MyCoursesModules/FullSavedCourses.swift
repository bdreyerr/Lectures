//
//  FullSavedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/11/25.
//

import SwiftUI

struct FullSavedCourses: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    var likedCourseIds: [String]
    var body: some View {
        VStack {
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
            
            ScrollView(showsIndicators: false) {
                ForEach(likedCourseIds, id: \.self) { courseId in
                    HStack {
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
                        Spacer()
                    }
                }
            }
            
            if myCourseController.currentCourseOffset < likedCourseIds.count {
                Button(action: {
                    myCourseController.loadMoreLikedCourses(courseIds: likedCourseIds, courseController: courseController)
                }) {
                    Text("Fetch more")
                        .font(.system(size: 12))
                }
                .padding(.top, 6)
                
                .buttonStyle(PlainButtonStyle())
            }
            
        }
        .padding(.bottom, 100)
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    FullSavedCourses()
//}
