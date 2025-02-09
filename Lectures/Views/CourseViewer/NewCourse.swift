//
//  NewCourse.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import SwiftUI
import YouTubePlayerKit

struct NewCourse: View {
    // System Vars
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // View Controllers
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var subscriptionController: SubscriptionController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    // View Arguments
    var course: Course
    
    // State
    @State var isLecturePlaying: Bool
    
    @State var playingLecture: Lecture?
    
    // We have the option to autoplay a lecture if clicking on a watch history
    var lastWatchedLectureId: String?
    var lastWatchedLectureNumber: Int?
    

    // YT Player
    @StateObject public var player: YouTubePlayer = ""
    
    var body: some View {
        if let courseId = course.id, let courseTitle = course.courseTitle, let channelId = course.channelId {
            VStack {
                // Course Image or Youtube Player
                if isLecturePlaying {
                    ZStack(alignment: .bottomLeading) {
                        
                        // make sure the youtube url is attatched to this lecture
                        YouTubePlayerView(self.player) { state in
                                // Overlay ViewBuilder closure to place an overlay View
                                // for the current `YouTubePlayer.State`
                                switch state {
                                case .idle:
                                    ProgressView()
//                                    SkeletonLoader(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                                case .ready:
                                    EmptyView()
                                case .error(let error):
                                    Text(verbatim: "YouTube player couldn't be loaded: \(error)")
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                    .shadow(radius: 2.5)
                } else {
                    if let image = courseController.courseThumbnails[courseId] {
                        Button(action: {
                            print("Course thumbnail tapped for course: \(courseTitle)")
                            playFirstLecture()
                        }) {
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                                
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Removes default button styling
                    }
                }
                
                VStack {
                    
                    NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                        Text("Link to the same course")
                    }
                    
                    // Course Title & Like Button
                    HStack {
                        // Course title and University
                        VStack {
                            Text(courseTitle)
                                .font(.system(size: 18, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        
                        LikeCourseButton(courseId: courseId)
                        
                    }
                    .padding(.top, 2)
                    
                    // Channel Info
                    ChannelInfo(channelId: channelId)
                    
                    NewCourseTabSwitcher(course: course,
                                         playingLecture: $playingLecture,
                                         isLecturePlaying: $isLecturePlaying,
                                         lastWatchedLectureNumber: lastWatchedLectureNumber,
                                         player: player)
                        .padding(.top, 5)
                        
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                // if last watched lecture was passed in, then autoplay
                if let _ = lastWatchedLectureNumber, let lastWatchedLectureId = lastWatchedLectureId {
                    print("The on appear getting called with a last watched lecture")
                    playLastWatchedLecture(lectureId: lastWatchedLectureId)
                } else {
                    print("no last watched")
                }
            }
            .onChange(of: player.source) {
                // when the video source changes, we know the user has watched a new video, and we should update course history accordingly.
                print("video player source is changing and we're trying to update watch history")
            
                if let rateLimit = rateLimiter.processWrite() {
                    print(rateLimit)
                    return
                }
                
                if let user = userController.user, let userId = user.id {
                    if subscriptionController.isPro {
                        if let playingLecture = playingLecture {
                            myCourseController.updateWatchHistory(userId: userId, course: course, lecture: playingLecture)
                        }
                    }
                }
            }
        } else {
            ErrorLoadingView()
        }
    }
    
    func playFirstLecture() {
        // Play the first lecture in the course
        if let lectureIds = course.lectureIds {
            if lectureIds.count == 0 { return }
            
            let firstLectureId = lectureIds[0]
            
            if let firstLecture = courseController.cachedLectures[firstLectureId] {
                if let youtubeVideoUrl = firstLecture.youtubeVideoUrl {
                    isLecturePlaying = true
                    self.player.source = .url(youtubeVideoUrl)
                    playingLecture = firstLecture
                }
            }
        }
    }
    
    func playLastWatchedLecture(lectureId: String) {
        // first ensure the lectureId passed is actually part of this course
        if let lectureIds = course.lectureIds {
            if !lectureIds.contains(lectureId) { return }
        }
        
        if let lecture = courseController.cachedLectures[lectureId] {
            if let youtubeVideoUrl = lecture.youtubeVideoUrl {
                self.player.source = .url(youtubeVideoUrl)
                self.playingLecture = lecture
            }
        } else {
            print("no lecture")
        }
    }
}
