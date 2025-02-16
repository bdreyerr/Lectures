//
//  LectureCardView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct LectureCardView: View {
    @EnvironmentObject var courseController: CourseController
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var lecture: Lecture
    
    var body: some View {
        Group {
            if let id = lecture.id, 
               let lectureTitle = lecture.lectureTitle, 
               let channelId = lecture.channelId, 
               let courseId = lecture.courseId {
                ZStack(alignment: .bottomLeading) {
                    if let image = courseController.courseThumbnails[courseId] {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        SkeletonLoader(width: cardWidth, height: cardHeight)
                    }
                    
                    // Add semi-transparent gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    // Play button overlay in center
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: playButtonSize, height: playButtonSize)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .allowsHitTesting(false)
                    
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(lectureTitle)
                                        .font(.system(size: titleFontSize, design: .serif))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                
                                // Lecture Number in course
                                HStack {
                                    if let lectureNumberInCourse = lecture.lectureNumberInCourse,
                                       let courseTitle = lecture.courseTitle {
                                        Text("Lecture #\(lectureNumberInCourse) in \(courseTitle)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .font(.system(size: subtitleFontSize, design: .serif))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                
                                HStack {
                                    if let channel = courseController.cachedChannels[channelId] {
                                        if let title = channel.title {
                                            Text(title)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .font(.system(size: subtitleFontSize, design: .serif))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                    
                                    if let lectureDuration = lecture.lectureDuration {
                                        Text("\(lectureDuration)")
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .font(.system(size: subtitleFontSize, design: .serif))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(contentPadding)
                    }
                    .padding(.bottom, 1)
                }
                .frame(width: cardWidth, height: cardHeight)
            }
        }
        .onAppear {
            // We need to fetch the relevant course in case the user wants to tap this lecture and watch it
            if let courseId = lecture.courseId {
                courseController.retrieveCourse(courseId: courseId)
                courseController.getCourseThumbnail(courseId: courseId)
            }
        }
    }
    
    // Computed properties for responsive sizing
    private var cardWidth: CGFloat {
        horizontalSizeClass == .regular ? 320 : 240
    }
    
    private var cardHeight: CGFloat {
        horizontalSizeClass == .regular ? 180 : 130
    }
    
    private var titleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 18 : 14
    }
    
    private var subtitleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 14 : 11
    }
    
    private var contentPadding: CGFloat {
        horizontalSizeClass == .regular ? 20 : 16
    }
    
    private var playButtonSize: CGFloat {
        horizontalSizeClass == .regular ? 65 : 50
    }
}

//#Preview {
//    LectureCardView()
//}
