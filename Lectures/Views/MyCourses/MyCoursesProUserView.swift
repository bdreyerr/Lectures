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
    @EnvironmentObject var myCourseController: MyCourseController
    @EnvironmentObject var userController: UserController
    
    // wHcontroller - on init get 3 latest WachHistory Objects, and when you get them also retrieve the course using Coursecontroller.Retrieve course which was passed as an argument
    
    var body: some View {
        Group {
            if myCourseController.isWatchHistoryLoading {
                HomeLoadingView()
            } else {
                
                CourseHistory()
                
                FollowedChannels()
                
                SavedCourses()
                
                SavedLectures()
                
            }
        }
        .onAppear {
            // clear the focus stack (we're back at the beginning of nav stack)
            courseController.focusedLectureStack = []
            courseController.focusedCourseStack = []
            
            if let user = Auth.auth().currentUser {
                myCourseController.retrieveRecentWatchHistories(userId: user.uid, courseController: courseController)
                // TODO: we don't need to do this every time
                if let user = userController.user {
                    myCourseController.retrieveFollowedChannels(channelIds: user.followedChannelIds!, courseController: courseController)
                    myCourseController.retrieveLikedCourses(courseIds: user.likedCourseIds!, courseController: courseController)
                    myCourseController.retrieveLikedLectures(lectureIds: user.likedLectureIds!, courseController: courseController)
                }
            } else {
                print("user isn't auth'd yet? idk")
            }
        }
    }
}

#Preview {
    MyCoursesProUserView()
}
