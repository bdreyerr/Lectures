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
                MyCoursesLoadingView()
            } else {
                
                CourseHistory()
                
                FollowedChannels()
                
                SavedCourses()
                
                SavedLectures()
                
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                print("on appear on MyCoursesProUserView")
                
                // get recent watch histories (will not update if already fetched)
                myCourseController.retrieveRecentWatchHistories(userId: user.uid, courseController: courseController)
                
                // fetch followed channels, liked courses and lectures, need to change every time
                if let user = userController.user, let followedChannelIds = user.followedChannelIds, let likedCourseIds = user.likedCourseIds, let likedLectureIds = user.likedLectureIds {
                    myCourseController.retrieveFollowedChannels(channelIds:followedChannelIds, courseController: courseController)
                    myCourseController.retrieveLikedCourses(courseIds: likedCourseIds, courseController: courseController)
                    myCourseController.retrieveLikedLectures(lectureIds: likedLectureIds, courseController: courseController)
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
