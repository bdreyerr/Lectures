//
//  FullSavedLectures.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/13/25.
//

import SwiftUI

struct FullSavedLectures: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    var likedLectureIds: [String]
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "newspaper")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Saved Lectures")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(showsIndicators: false) {
                ForEach(likedLectureIds, id: \.self) { lectureId in
                    HStack {
                        if let lecture = courseController.cachedLectures[lectureId], let lectureId = lecture.id, let courseId = lecture.courseId, let lectureNumberInCourse = lecture.lectureNumberInCourse {
                            
                            if let course = courseController.cachedCourses[courseId] {
                                NavigationLink(destination: NewCourse(course: course, isLecturePlaying: true, playingLecture: lecture, lastWatchedLectureId: lectureId, lastWatchedLectureNumber: lectureNumberInCourse)) {
                                    LectureCardView(lecture: lecture)
                                }
                                .simultaneousGesture(TapGesture().onEnded { _ in
                                    courseController.focusCourse(course)
                                })
                            }
                        }
                        Spacer()
                    }
                }
            }
            
            if myCourseController.currentLectureOffset < likedLectureIds.count {
                Button(action: {
                    myCourseController.loadMoreLikedLectures(lectureIds: likedLectureIds, courseController: courseController)
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
//    FullSavedLectures()
//}
