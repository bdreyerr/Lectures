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
                Text("Saved Lectures")
                    .font(.system(size: 13, design: .serif))
                    .bold()
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(likedLectureIds, id: \.self) { lectureId in
                        if let lecture = courseController.cachedLectures[lectureId] {
                            NavigationLink(destination: LectureView()) {
                                LectureCardView(lecture: lecture)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                courseController.focusLecture(lecture)
                                courseController.retrieveCourse(courseId: lecture.courseId!)
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
