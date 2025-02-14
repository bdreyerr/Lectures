//
//  LectureSearchResult.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/19/25.
//

import SwiftUI

struct LectureSearchResult: View {
    @EnvironmentObject var courseController: CourseController
    
    var lecture: Lecture
    @State var course: Course?
    
    var body: some View {
        Group {
            if let id = lecture.id, let courseId = lecture.courseId, let lectureTitle = lecture.lectureTitle, let lectureNumberInCourse = lecture.lectureNumberInCourse, let viewsOnYouTube = lecture.viewsOnYouTube {
                if let course = courseController.cachedCourses[courseId] {
                    NavigationLink(destination: NewCourse(course: course, isLecturePlaying: true, playingLecture: lecture, lastWatchedLectureId: id, lastWatchedLectureNumber: lectureNumberInCourse)) {
                        HStack {
                            ZStack {
                                if let image = courseController.lectureThumbnails[id] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill) // Fill the frame while maintaining aspect ratio
                                        .frame(width: 120, height: 67.5)
                                        .clipped() // Clip the image to the frame
                                        .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply rounded corners
                                } else {
                                    // default image when not loaded
                                    SkeletonLoader(width: 120, height: 67.5)
                                }
                                
                                Image(systemName: "play.circle.fill") // SF Symbol for play button
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            
                            VStack {
                                HStack {
                                    Text(lectureTitle)
                                        .font(.system(size: 16, design: .serif))
                                        .bold()
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    // TODO: add a field course name on the lecture object
                                    Text("Lecture # \(lectureNumberInCourse) in The Emotion Machine")
                                        .font(.system(size: 12))
                                        .opacity(0.6)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Spacer()
                                }
                                
                                
                                HStack {
                                    Text("\(formatIntViewsToString(numViews: viewsOnYouTube)) Views")
                                        .font(.system(size: 12))
                                        .opacity(0.6)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 280)
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded { _ in
                        //                    courseController.focusLecture(lecture)
                        courseController.focusCourse(course)
                    })
                } else {
                    SkeletonLoader(width: 120, height: 67.5)
                }
            }
        }
        .onAppear {
            // We need to fetch the relevant course in case the user wants to tap this lecture and watch it
            if let courseId = lecture.courseId {
                courseController.retrieveCourse(courseId: courseId)
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
//    LectureSearchResult()
//}
