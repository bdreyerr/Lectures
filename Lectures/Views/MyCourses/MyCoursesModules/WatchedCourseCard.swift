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
    
    var course: Course
    var watchHistory: WatchHistory
    
    private var watchProgress: CGFloat {
        if let watchHistoryLectureNumberInCourse = watchHistory.lectureNumberInCourse, let courseNumLecturesInCourse = course.numLecturesInCourse {
            let progress = CGFloat(watchHistoryLectureNumberInCourse) / CGFloat(courseNumLecturesInCourse)
            return min(max(progress, 0), 1) // Ensure progress is between 0 and 1
        } else {
            return 0
        }
    }
    
    private var progressColor: Color {
        watchProgress >= 1.0 ? .green : .red
    }
    
    var body: some View {
        Group {
            if let courseId = course.id, let courseTitle = course.courseTitle, let channelId = course.channelId, let numLecturesInCourse = course.numLecturesInCourse, let watchTimeInHrs = course.watchTimeInHrs {
                
                ZStack(alignment: .bottomLeading) {
                    if let image = courseController.courseThumbnails[courseId] {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Fill the frame while maintaining aspect ratio
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 130) // Set the desired frame size
                            .clipped() // Clip the image to the frame
                            .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply rounded corners
                    } else {
                        // Default image when not loaded
                        SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 130)
                    }
                    
                    // Add semi-transparent gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 130) // Match the frame size of the image
                    .clipped() // Clip the image to the frame
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply rounded corners to match the image
                    
                    
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(courseTitle)
                                        .font(.system(size: 14, design: .serif))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading) // Ensure text aligns to the left
                                        .lineLimit(4) // Limit to two lines if necessary
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                
                                HStack {
                                    // TODO: Add back university name
                                    if let channel = courseController.cachedChannels[channelId], let channelTitle = channel.title  {
                                        Text(channelTitle)
                                            .lineLimit(1) // Limit to a single line
                                            .truncationMode(.tail) // Use ellipsis for truncation
                                            .font(.system(size: 11, design: .serif))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    Text("\(numLecturesInCourse) Lectures")
                                        .font(.system(size: 11, design: .serif))
                                        .foregroundColor(.white.opacity(0.8))
                                    Text("\(watchTimeInHrs)hrs")
                                        .font(.system(size: 11, design: .serif))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .padding(.bottom, 1)
                    
                    // Add progress bar at the bottom
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: geometry.size.width * watchProgress, height: 3)
                            .position(x: (geometry.size.width * watchProgress) / 2, y: geometry.size.height - 1.5)
                    }
                    .cornerRadius(10)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 130)
                .shadow(radius: 2.5)
            }
        }
        .onAppear {
            // we should fetch the last watched lecture here, in case the user clicks on this watched course card so we can autoplay the lecture in question
            if let lectureId = watchHistory.lectureId {
                courseController.retrieveLecture(lectureId: lectureId)
            }
        }
    }
}
