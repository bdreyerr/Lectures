//
//  TabLectures.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import SwiftUI
import YouTubePlayerKit

struct TabLectures: View {
    @EnvironmentObject var courseController: CourseController
    
    var course: Course
    
    @Binding var playingLecture: Lecture?
    @Binding var isLecturePlaying: Bool
    
    // Optional to pass in when we want to init lecture loading around a certain lecture number and not lecture 0
    var lastWatchedLectureNumber: Int?
    
    @ObservedObject var player: YouTubePlayer
    
    // [LectureId]
    @Binding var currentLoadedLectures: [String]
    
    @Binding var hasAppeared: Bool
    
    func playLecture(lecture: Lecture) {
        self.playingLecture = lecture
        if let youtubeVideoUrl = lecture.youtubeVideoUrl {
            self.player.source = .url(youtubeVideoUrl)
            isLecturePlaying = true
        }
    }
    
    
    func retrieveLectures() {
        // first we wanna know if we are loading lectures around a playing lecture, if this is the case, we need to load 8 lectures, with the playing lecture in the middle.
        if isLecturePlaying {
            
            // get the number of the current playing lecture
            if let playingLecture = playingLecture, let lectureNumberInCourse = playingLecture.lectureNumberInCourse {
                // we want to load 3 before, the current lecture, and 4 after, if there are less than 3 before, we add how many are missing to after, and same if after are missing, we add to before
                
                // lectureIds [String], playingLecture: Lecure
                
                // find the index of the playing lecture in lectureIds
                if let lectureIds = course.lectureIds {
                    let sortedLectureIds = lectureIds.sorted()
                    let playingLectureIndex: Int = sortedLectureIds.firstIndex(where: { $0 == playingLecture.id }) ?? 0
                    
                    // Calculate how many lectures we can load before and after
                    let maxBefore = 3
                    let maxAfter = 4
                    
                    // Calculate available lectures before and after
                    let availableBefore = playingLectureIndex
                    let availableAfter = sortedLectureIds.count - playingLectureIndex - 1
                    
                    // Initially set the number of lectures to load
                    var numBefore = min(availableBefore, maxBefore)
                    var numAfter = min(availableAfter, maxAfter)
                    
                    // If we couldn't get enough lectures before, add more after
                    let remainingBefore = maxBefore - numBefore
                    if remainingBefore > 0 {
                        numAfter = min(numAfter + remainingBefore, availableAfter)
                    }
                    
                    // If we couldn't get enough lectures after, add more before
                    let remainingAfter = maxAfter - numAfter
                    if remainingAfter > 0 {
                        numBefore = min(numBefore + remainingAfter, availableBefore)
                    }
                    
                    // Calculate the final range
                    let startIndex = playingLectureIndex - numBefore
                    let endIndex = playingLectureIndex + numAfter + 1 // +1 because the range is exclusive
                    
                    // Get the lecture IDs to load
                    let lecturesToLoad = Array(sortedLectureIds[startIndex..<endIndex])
                    courseController.retrieveLecturesInCourse(courseId: course.id!, lectureIdsToLoad: lecturesToLoad)
                    self.currentLoadedLectures = lecturesToLoad
                }
            }
        } else {
            // otherwise, we are just loading a course, and want to retrieve the first 8 lectures in the course
            if let courseId = course.id, let lectureIds = course.lectureIds {
                let sortedLectureIds = lectureIds.sorted()
                
                let lecturesToLoad = Array(sortedLectureIds.prefix(8))
                courseController.retrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: lecturesToLoad)
                self.currentLoadedLectures = lecturesToLoad
            }
        }
    }
    
    func retrievePreviousLectures() {
        guard let lectureIds = course.lectureIds else { return }
        
        let sortedLectureIds = lectureIds.sorted()
        
        // Find the earliest loaded lecture's index
        guard let earliestLoadedId = currentLoadedLectures.min(),
              let earliestLoadedIndex = sortedLectureIds.firstIndex(of: earliestLoadedId) else {
            return
        }
        
        // Calculate how many lectures we can load before
        let numToLoad = 8
        let startIndex = max(0, earliestLoadedIndex - numToLoad)
        let endIndex = earliestLoadedIndex
        
        // Get the lecture IDs to load
        let lecturesToLoad = Array(sortedLectureIds[startIndex..<endIndex])
        
        // Only proceed if we have lectures to load
        guard !lecturesToLoad.isEmpty else { return }
        
        courseController.retrieveLecturesInCourse(courseId: course.id!, lectureIdsToLoad: lecturesToLoad)
        
        // Update currentLoadedLectures to include both the new and existing lectures
        // Insert new lectures at the beginning since they come before current ones
        self.currentLoadedLectures.insert(contentsOf: lecturesToLoad, at: 0)
    }
    
    func retrieveFollowingLectures() {
        guard let lectureIds = course.lectureIds else { return }
        
        let sortedLectureIds = lectureIds.sorted()
        
        // Find the latest loaded lecture's index
        guard let latestLoadedId = currentLoadedLectures.max(),
              let latestLoadedIndex = sortedLectureIds.firstIndex(of: latestLoadedId) else {
            return
        }
        
        // Calculate how many lectures we can load after
        let numToLoad = 8
        let startIndex = latestLoadedIndex + 1
        let endIndex = min(sortedLectureIds.count, startIndex + numToLoad)
        
        // Get the lecture IDs to load
        let lecturesToLoad = Array(sortedLectureIds[startIndex..<endIndex])
        
        // Only proceed if we have lectures to load
        guard !lecturesToLoad.isEmpty else { return }
        
        courseController.retrieveLecturesInCourse(courseId: course.id!, lectureIdsToLoad: lecturesToLoad)
        
        // Update currentLoadedLectures to include both existing and new lectures
        // Append new lectures at the end since they come after current ones
        self.currentLoadedLectures.append(contentsOf: lecturesToLoad)
    }
    
    var body: some View {
        if let lectureIds = course.lectureIds {
            VStack {
                ScrollView() {
                    
                    if courseController.isLecturesInCourseLoading {
                        ForEach(0..<5, id: \.self) { _ in
                            HStack {
                                SkeletonLoader(width: 350, height: 30)
                                    .padding(.bottom, 2)
                                Spacer()
                            }
                        }
                    } else {
                        
                        
                        if let earliestLoadedId = currentLoadedLectures.min(),
                           let lectureIds = course.lectureIds,
                           let earliestLoadedIndex = lectureIds.sorted().firstIndex(of: earliestLoadedId),
                           earliestLoadedIndex > 0 {  // Check if there are lectures before the earliest loaded one
                            
                            
                            
                            FetchButton(isMore: false) {
                                retrievePreviousLectures()
                            }
                            .padding(.bottom, 10)
                            
                        }
                        
                        ForEach(lectureIds, id: \.self) { lectureId in
                            if let lecture = courseController.cachedLectures[lectureId] {
                                if let playingLecture = playingLecture, let playingLectureId = playingLecture.id  {
                                    Button(action: {
                                        playLecture(lecture: lecture)
                                    }) {
                                        LectureInCourse(lecture: lecture, playingLectureId: playingLectureId)
                                            .padding(.bottom, 10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    Button(action: {
                                        playLecture(lecture: lecture)
                                    }) {
                                        LectureInCourse(lecture: lecture)
                                            .padding(.bottom, 10)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        if let latestLoadedId = currentLoadedLectures.max(),
                           let lectureIds = course.lectureIds,
                           let latestLoadedIndex = lectureIds.sorted().firstIndex(of: latestLoadedId),
                           latestLoadedIndex < lectureIds.count - 1 {  // Check if there are lectures after the latest loaded one
                            
                            
                            FetchButton(isMore: true) {
                                retrieveFollowingLectures()
                            }
                            .padding(.top, 6)
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
            .padding(.top, 10)
            .onAppear {
                print("is lecture playing?", isLecturePlaying)
                
                print(" we are retrieving lectures again, value of hasAppeared: \(hasAppeared) ")
                guard !hasAppeared else { return }
                hasAppeared = true
                
                retrieveLectures()
            }
        }
    }
}

struct LectureInCourse: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var subscriptionController: SubscriptionController
    @EnvironmentObject var rateLimiter: RateLimiter
    
    var lecture: Lecture
    var playingLectureId: String?
    
    @State var isLectureLiked: Bool = false
    
    @State private var isUpgradeAccountSheetShowing: Bool = false
    @State private var isProAccountButNotRegisteredSheetShowing: Bool = false
    
    var body: some View {
        if let lectureId = lecture.id, let lectureTitle = lecture.lectureTitle, let lectureNumberInCourse = lecture.lectureNumberInCourse, let viewsOnYouTube = lecture.viewsOnYouTube {
            HStack {
                // Lecture number in course
                Text("\(lectureNumberInCourse)")
                    .font(.system(size: 12, design: .serif))
                
                // Lecture title, duration and number plays
                VStack {
                    // Check mark if user watched this lecture already
                    
                    HStack {
                        Text(lectureTitle)
                            .font(.system(size: 14, design: .serif))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                        
                        // Like Lecture Button
                        Button(action: {
                            if let user = userController.user, let userId = user.id {
                                if let rateLimit = rateLimiter.processWrite() {
                                    print(rateLimit)
                                    return
                                }
                                
                                userController.likeLecture(userId: userId, lectureId: lectureId)
                                withAnimation(.spring()) {
                                    self.isLectureLiked.toggle()
                                }
                            } else {
                                isProAccountButNotRegisteredSheetShowing = true
                            }
                        }) {
                            Image(systemName: isLectureLiked ? "heart.fill" : "heart")
                                .font(.system(size: 12, design: .serif))
                                .foregroundStyle(isLectureLiked ? Color.red : colorScheme == .light ? Color.black : Color.white)
                        }
                        .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
                        }
                        .sheet(isPresented: $isProAccountButNotRegisteredSheetShowing) {
                            ProAccountButNotSignedInSheet(displaySheet: $isProAccountButNotRegisteredSheetShowing)
                        }
                        .padding(.trailing, 10)
                    }
                    
                    HStack {
                        if let lectureDuration = lecture.lectureDuration  {
                            // Duration
                            
                            StatItem(icon: "play.circle", text: "\(lectureDuration)")
                            
                            
                            //                            Text("\(lectureDuration)")
                            //                                .font(.system(size: 12))
                            //                                .opacity(0.6)
                        }
                        
                        StatItem(icon: "eye", text: "\(formatIntViewsToString(numViews: viewsOnYouTube)) Views")
                        Spacer()
                    }
                }
            }
            .padding(lectureId == playingLectureId ? 8 : 0)
            .background(
                RoundedRectangle(cornerRadius: 8)
                //                    .fill(Color.gray.opacity(0.2))
                    .fill(lectureId == playingLectureId ? Color.gray.opacity(0.2) : Color.clear)
            )
            .onAppear {
                if let user = userController.user, let likedLectureIds = user.likedLectureIds {
                    if likedLectureIds.contains(lectureId) {
                        self.isLectureLiked = true
                    }
                }
            }
        }
    }
    
    func formatIntViewsToString(numViews: Int) -> String {
        switch numViews {
        case 0..<1_000:
            return String(numViews)
        case 1_000..<1_000_000:
            let thousands = Double(numViews) / 1_000.0
            return String(format: "%.0fk", thousands)
        case 1_000_000...:
            let millions = Double(numViews) / 1_000_000.0
            return String(format: "%.0fM", millions)
        default:
            return "0"
        }
    }
}

//#Preview {
//    TabLectures()
//}
