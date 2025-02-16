//
//  WatchedCourseCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/15/25.
//

import SwiftUI

struct WatchedCourseCard: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var course: Course
    var watchHistory: WatchHistory
    
    private var watchProgress: CGFloat {
        if let watchHistoryLectureNumberInCourse = watchHistory.lectureNumberInCourse, 
           let courseNumLecturesInCourse = course.numLecturesInCourse {
            let progress = CGFloat(watchHistoryLectureNumberInCourse) / CGFloat(courseNumLecturesInCourse)
            return min(max(progress, 0), 1)
        } else {
            return 0
        }
    }
    
    private var progressColor: Color {
        watchProgress >= 1.0 ? .green : .red
    }
    
    var body: some View {
        Group {
            if let courseId = course.id, 
               let courseTitle = course.courseTitle, 
               let channelId = course.channelId, 
               let numLecturesInCourse = course.numLecturesInCourse, 
               let watchTimeInHrs = course.watchTimeInHrs {
                
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
                    
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(courseTitle)
                                        .font(.system(size: titleFontSize, design: .serif))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                
                                HStack {
                                    if let channel = courseController.cachedChannels[channelId], 
                                       let channelTitle = channel.title {
                                        Text(channelTitle)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .font(.system(size: subtitleFontSize, design: .serif))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Text("\(numLecturesInCourse) Lectures")
                                        .font(.system(size: subtitleFontSize, design: .serif))
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("\(watchTimeInHrs)hrs")
                                        .font(.system(size: subtitleFontSize, design: .serif))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            Spacer()
                        }
                        .padding(contentPadding)
                    }
                    .padding(.bottom, 1)
                    
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: geometry.size.width * watchProgress, height: progressBarHeight)
                            .position(x: (geometry.size.width * watchProgress) / 2, y: geometry.size.height - progressBarHeight/2)
                    }
                    .cornerRadius(10)
                }
                .frame(width: cardWidth, height: cardHeight)
                .shadow(radius: 2.5)
            }
        }
        .onAppear {
            if let lectureId = watchHistory.lectureId {
                courseController.retrieveLecture(lectureId: lectureId)
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
    
    private var progressBarHeight: CGFloat {
        horizontalSizeClass == .regular ? 4 : 3
    }
}
