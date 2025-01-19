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
                Text("Saved Courses")
                    .font(.system(size: 13, design: .serif))
                    .bold()
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(likedCourseIds, id: \.self) { courseId in
                        if let course = courseController.cachedCourses[courseId] {
                            NavigationLink(destination: CourseView()) {
                                if let watchHistory = myCourseController.cachedWatchHistories[courseId] {
                                    WatchedCourseCard(course: course, watchHistory: watchHistory)
                                } else {
                                    CourseCardView(course: course)
                                }
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
