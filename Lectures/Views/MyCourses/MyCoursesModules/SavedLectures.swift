//
//  SavedLectures.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct SavedLectures: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    @State private var likedLectureIds: [String] = []
    
    var body: some View {
        Group {
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(likedLectureIds, id: \.self) { lectureId in
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
                    }
                }
            }
            HStack {
                NavigationLink(destination: FullSavedLectures(likedLectureIds: likedLectureIds)) {
                    Text("View All")
                        .font(.system(size: 10))
                }
                .buttonStyle(PlainButtonStyle())
//                
                Spacer()
            }
            .padding(.top, 1)
        }
        .onAppear {
            // We need to fetch the relevant course in case the user wants to tap this lecture and watch it
            if let user = userController.user {
                // Update the state variable when `user` changes
                DispatchQueue.main.async {
                    likedLectureIds = (user.likedLectureIds ?? []).reversed()
                }
            }
        }
    }
}

#Preview {
    SavedLectures()
}
