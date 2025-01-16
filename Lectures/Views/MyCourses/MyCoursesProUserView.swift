//
//  MyCoursesProUserView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/15/25.
//

import FirebaseAuth
import SwiftUI

struct MyCoursesProUserView: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var watchHistoryController: WatchHistoryController
//    @EnvironmentObject var userController: UserController
    
    // wHcontroller - on init get 3 latest WachHistory Objects, and when you get them also retrieve the course using Coursecontroller.Retrieve course which was passed as an argument
    
    var body: some View {
        Group {
            HStack {
                Text("Course History")
                    .font(.system(size: 13, design: .serif))
                    .bold()
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(watchHistoryController.recentWatchHistories, id: \.id) { watchHistory in
                        if let course = courseController.cachedCourses[watchHistory.courseId!] {
                            NavigationLink(destination: CourseView()) {
                                WatchedCourseCard(course: course, watchHistory: watchHistory)
                            }
                            .simultaneousGesture(TapGesture().onEnded { _ in
                                
                            })
                        }
                    }
                }
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                watchHistoryController.retrieveRecentWatchHistories(userId: user.uid, courseController: courseController)
            } else {
                print("user isn't auth'd yet? idk")
            }
        }
    }
}

#Preview {
    MyCoursesProUserView()
}
