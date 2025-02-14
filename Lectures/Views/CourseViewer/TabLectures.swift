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
    
    // Add this helper struct to store lecture ID and its number
    private struct LectureOrderInfo {
        let id: String
        let number: Int
    }
    
    @Binding var hasAppeared: Bool
    
    func playLecture(lecture: Lecture) {
        self.playingLecture = lecture
        if let youtubeVideoUrl = lecture.youtubeVideoUrl {
            self.player.source = .url(youtubeVideoUrl)
            isLecturePlaying = true
        }
    }
    
    func retrieveLectures(isPrevious: Bool) {
        print(" we are retrieving lectures again, value of hasAppeared: \(hasAppeared) ")
        guard let courseId = course.id, let lectureIds = course.lectureIds else { return }
        
        // Create ordered mapping of all available lectures
        let availableLectures: [LectureOrderInfo] = lectureIds.compactMap { lectureId in
            if let lecture = courseController.cachedLectures[lectureId] {
                return LectureOrderInfo(id: lectureId, number: lecture.lectureNumberInCourse ?? 0)
            }
            // If not in cache yet, create with assumed order based on ID
            return LectureOrderInfo(id: lectureId, number: Int(lectureId) ?? 0)
        }.sorted(by: { $0.number < $1.number })
        
        // First load
        if currentLoadedLectures.isEmpty {
            let startIndex: Int
            if let lastWatched = lastWatchedLectureNumber {
                // Find the closest index to lastWatched - 4
                startIndex = max(0, min(
                    availableLectures.firstIndex(where: { $0.number >= lastWatched }) ?? 0,
                    availableLectures.count - 8
                ))
            } else {
                startIndex = 0
            }
            
            let endIndex = min(startIndex + 8, availableLectures.count)
            let lectureIdsToLoad = availableLectures[startIndex..<endIndex].map { $0.id }
            
            courseController.retrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: Array(lectureIdsToLoad))
            self.currentLoadedLectures = Array(lectureIdsToLoad)
        } else {
            // Find current range of loaded lectures
            let currentLoadedNumbers = currentLoadedLectures.compactMap { lectureId in
                courseController.cachedLectures[lectureId]?.lectureNumberInCourse
            }
            
            guard let minLoaded = currentLoadedNumbers.min(),
                  let maxLoaded = currentLoadedNumbers.max() else { return }
            
            if isPrevious {
                // Load previous 8 lectures
                let previousLectures = availableLectures.filter {
                    $0.number < minLoaded
                }.suffix(8)
                
                if !previousLectures.isEmpty {
                    let lectureIdsToLoad = previousLectures.map { $0.id }
                    courseController.retrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: Array(lectureIdsToLoad))
                    self.currentLoadedLectures.insert(contentsOf: lectureIdsToLoad, at: 0)
                }
            } else {
                // Load next 8 lectures
                let nextLectures = availableLectures.filter {
                    $0.number > maxLoaded
                }.prefix(8)
                
                if !nextLectures.isEmpty {
                    let lectureIdsToLoad = nextLectures.map { $0.id }
                    courseController.retrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: Array(lectureIdsToLoad))
                    self.currentLoadedLectures.append(contentsOf: lectureIdsToLoad)
                }
            }
        }
        
        // Always ensure lectures are sorted by lecture number
        self.currentLoadedLectures.sort {
            (courseController.cachedLectures[$0]?.lectureNumberInCourse ?? 0) <
                (courseController.cachedLectures[$1]?.lectureNumberInCourse ?? 0)
        }
    }
    
    var body: some View {
        VStack {
            ScrollView() {
                
                if currentLoadedLectures.isEmpty {
                    ForEach(0..<5, id: \.self) { _ in
                        HStack {
                            SkeletonLoader(width: 350, height: 30)
                                .padding(.bottom, 2)
                            Spacer()
                        }
                    }
                } else {
                    if let lectureIds = course.lectureIds {
                        // Get the lecture number of our first loaded lecture
                        if let firstLoadedNumber = currentLoadedLectures.first.flatMap({
                            courseController.cachedLectures[$0]?.lectureNumberInCourse
                        }) {
                            // Check if there are any lectures with lower numbers
                            let hasEarlierLectures = lectureIds.contains { lectureId in
                                if let lecture = courseController.cachedLectures[lectureId],
                                   let number = lecture.lectureNumberInCourse {
                                    return number < firstLoadedNumber
                                }
                                return false
                            }
                            
                            if hasEarlierLectures {
                                Button(action: {
                                    retrieveLectures(isPrevious: true)
                                }) {
                                    Text("Fetch Previous")
                                        .font(.system(size: 12))
                                }
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    
                    ForEach(currentLoadedLectures.sorted(by: {
                        (courseController.cachedLectures[$0]?.lectureNumberInCourse ?? 0) <
                            (courseController.cachedLectures[$1]?.lectureNumberInCourse ?? 0)
                    }), id: \.self) { lectureId in
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
                    
                    if let lectureIds = course.lectureIds {
                        // Get the lecture number of our last loaded lecture
                        if let lastLoadedNumber = currentLoadedLectures.last.flatMap({
                            courseController.cachedLectures[$0]?.lectureNumberInCourse
                        }) {
                            // Check if there are any lectures with higher numbers
                            let hasMoreLectures = lectureIds.contains { lectureId in
                                if let lecture = courseController.cachedLectures[lectureId],
                                   let number = lecture.lectureNumberInCourse {
                                    return number > lastLoadedNumber
                                }
                                return false
                            }
                            
                            if hasMoreLectures {
                                Button(action: {
                                    retrieveLectures(isPrevious: false)
                                }) {
                                    Text("Fetch more")
                                        .font(.system(size: 12))
                                }
                                .padding(.top, 6)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 10)
        .onAppear {
            print("count of current loaded lectures: ", self.currentLoadedLectures.count)
            print(" we are retrieving lectures again, value of hasAppeared: \(hasAppeared) ")
            guard !hasAppeared else { return }
            hasAppeared = true
            
            retrieveLectures(isPrevious: false)
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
                            if subscriptionController.isPro {
                                if let user = userController.user, let userId = user.id {
                                    if let rateLimit = rateLimiter.processWrite() {
                                        print(rateLimit)
                                        return
                                    }
                                    
                                    userController.likeLecture(userId: userId, lectureId: lectureId)
                                    withAnimation(.spring()) {
                                        self.isLectureLiked.toggle()
                                    }
                                }
                                return
                            }

                            self.isUpgradeAccountSheetShowing = true
                        }) {
                            Image(systemName: isLectureLiked ? "heart.fill" : "heart")
                                .font(.system(size: 12, design: .serif))
                                .foregroundStyle(isLectureLiked ? Color.red : colorScheme == .light ? Color.black : Color.white)
                        }
                        .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
                        }
                        .padding(.trailing, 10)
                    }
                    
                    HStack {
                        // Duration?
                        Text("54:92 mins")
                            .font(.system(size: 12))
                            .opacity(0.6)
                        
                        Text("\(formatIntViewsToString(numViews: viewsOnYouTube)) Views")
                            .font(.system(size: 12))
                            .opacity(0.6)
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
