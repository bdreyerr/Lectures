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
    @State var currentLoadedLectures: [String] = []
    
    func playLecture(lecture: Lecture) {
        self.playingLecture = lecture
        if let youtubeVideoUrl = lecture.youtubeVideoUrl {
            self.player.source = .url(youtubeVideoUrl)
            isLecturePlaying = true
        }
    }
    
    func retrieveLectures(isPrevious: Bool) {
        if let courseId = course.id, let lectureIds = course.lectureIds {
            // first time
            if self.currentLoadedLectures.isEmpty {
                let startIndex: Int
                if let lastWatched = lastWatchedLectureNumber {
                    // Start 4 lectures before the last watched lecture (if possible)
                    startIndex = max(0, min(lastWatched - 4, lectureIds.count - 8))
                } else {
                    // If no last watched lecture, start from beginning
                    startIndex = 0
                }
                let endIndex = min(startIndex + 8, lectureIds.count)
                let firstEightLectureIds = Array(lectureIds[startIndex..<endIndex])
                courseController.newRetrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: firstEightLectureIds)
                self.currentLoadedLectures = firstEightLectureIds
            } else {
                if isPrevious {
                    // Find the starting index for the previous batch
                    if let firstLoadedIndex = lectureIds.firstIndex(of: currentLoadedLectures.first!) {
                        let startIndex = max(0, firstLoadedIndex - 8)
                        let count = firstLoadedIndex - startIndex
                        let previousLectureIds = Array(lectureIds[startIndex..<firstLoadedIndex])
                        courseController.newRetrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: previousLectureIds)
                        self.currentLoadedLectures.insert(contentsOf: previousLectureIds, at: 0)
                    }
                } else {
                    // Find the starting index for the next batch
                    let startIndex = currentLoadedLectures.count
                    if startIndex < lectureIds.count {
                        // Get next 8 lectures, but don't exceed array bounds
                        let nextEightLectureIds = Array(lectureIds[startIndex..<min(startIndex + 8, lectureIds.count)])
                        courseController.newRetrieveLecturesInCourse(courseId: courseId, lectureIdsToLoad: nextEightLectureIds)
                        self.currentLoadedLectures.append(contentsOf: nextEightLectureIds)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if let lectureIds = course.lectureIds {
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
                            // Show "Load Previous" button if there are earlier unloaded lectures
                            if !currentLoadedLectures.isEmpty && currentLoadedLectures.first != lectureIds.first {
                                Button(action: {
                                    retrieveLectures(isPrevious: true)
                                }) {
                                    Text("Fetch Previous")
                                        .font(.system(size: 12))
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        
                        ForEach(currentLoadedLectures, id: \.self) { lectureId in
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
                        
                        if currentLoadedLectures.count != lectureIds.count {
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
        .padding(.top, 10)
        .onAppear {
            // For now just call the retrieve lectuers in course, and we'll do all of them
            retrieveLectures(isPrevious: false)
        }
    }
}

struct LectureInCourse: View {
    var lecture: Lecture
    var playingLectureId: String?
    
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
