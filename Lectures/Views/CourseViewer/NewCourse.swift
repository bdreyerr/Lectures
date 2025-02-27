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
    
    // Add this state variable at the top with other @State properties
    @State private var hasAppeared = false
    
    // Add new state for tracking size
    @State private var viewSize: CGSize = .zero
    
    var playerHeight: CGFloat {
        // Calculate height based on 16:9 aspect ratio
        // For iPad, limit the max width to maintain reasonable size
        let maxWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 800 : UIScreen.main.bounds.width
        let width = min(viewSize.width, maxWidth)
        return width * 0.5625 // 9/16 = 0.5625 for standard video aspect ratio
    }
    
    var body: some View {
        if let courseId = course.id, let courseTitle = course.courseTitle, let channelId = course.channelId {
            GeometryReader { geometry in
                VStack {
                    // Course Image or Youtube Player
                    if isLecturePlaying {
                        ZStack(alignment: .bottomLeading) {
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
                            .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 800 : nil)
                            .frame(height: playerHeight)
                            .frame(maxWidth: .infinity) // Center the player
                        }
                        .frame(height: playerHeight)
                        .shadow(radius: 2.5)
                    } else {
                        if let image = courseController.courseThumbnails[courseId] {
                            Button(action: {
                                print("Course thumbnail tapped for course: \(courseTitle)")
                                // make sure lectures are loaded first
                                if let lectures = course.lectureIds {
                                    playFirstLecture()
                                } else {
                                    print("no lectures to play")
                                }
                            }) {
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 800 : nil)
                                        .frame(height: playerHeight)
                                        .frame(maxWidth: .infinity) // Center the image
                                        .clipped()
                                    
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white)
                                        .opacity(0.8)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    VStack {
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
                    viewSize = geometry.size
                    // Only execute this block on first appearance
                    guard !hasAppeared else { return }
                    hasAppeared = true
                    
                    // if last watched lecture was passed in, then autoplay
                    if let _ = lastWatchedLectureNumber, let lastWatchedLectureId = lastWatchedLectureId {
                        print("The on appear getting called with a last watched lecture")
                        playLastWatchedLecture(lectureId: lastWatchedLectureId)
                    } else {
                        print("no last watched")
                    }
                }
                .onChange(of: geometry.size) { newSize in
                    viewSize = newSize
                }
                .onChange(of: player.source) {
                    // when the video source changes, we know the user has watched a new video, and we should update course history accordingly.
                    print("video player source is changing and we're trying to update watch history")
                    
                    
                    // If the user is signed in, we'll save their watch history.
                    if let user = userController.user, let userId = user.id {
                        if let playingLecture = playingLecture {
                            if course.id == nil {
                                print("course id is nil for some readosn?")
                            }
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
            
            // Find the lecture where numLectureInCourse == 1
            var firstLecture: Lecture?
            for lectureId in lectureIds {
                if let loadedLecture = courseController.cachedLectures[lectureId] {
                    if loadedLecture.lectureNumberInCourse == 1 {
                        firstLecture = loadedLecture
                    }
                }
            }
    
            
            if let firstLecture = firstLecture {
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
