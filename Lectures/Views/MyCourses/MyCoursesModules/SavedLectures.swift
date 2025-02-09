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
                        if let lecture = courseController.cachedLectures[lectureId], let courseId = lecture.courseId {
                            NavigationLink(destination: LectureView()) {
                                LectureCardView(lecture: lecture)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                courseController.focusLecture(lecture)
                                courseController.retrieveCourse(courseId: courseId)
                            })
                        }
                    }
                    
                    
                }
            }
        }
        .onAppear {
            if let user = userController.user {
                // Update the state variable when `user` changes
                DispatchQueue.main.async {
                    likedLectureIds = user.likedLectureIds ?? []
                }
            }
        }
    }
}

#Preview {
    SavedLectures()
}
