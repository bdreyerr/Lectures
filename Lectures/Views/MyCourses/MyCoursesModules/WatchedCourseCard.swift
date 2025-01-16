//
//  WatchedCourseCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/15/25.
//

import SwiftUI

struct WatchedCourseCard: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var watchHistoryController: WatchHistoryController
    
    var course: Course
    var watchHistory: WatchHistory
    
    private var watchProgress: CGFloat {
        let progress = CGFloat(watchHistory.lectureNumberInCourse!) / CGFloat(course.numLecturesInCourse!)
        return min(max(progress, 0), 1) // Ensure progress is between 0 and 1
    }
    
    private var progressColor: Color {
        watchProgress >= 1.0 ? .green : .red
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = courseController.courseThumbnails[course.id!] {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                // default image when not loaded
                SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
            }
            
            // Add semi-transparent gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(course.courseTitle!)
                                .font(.system(size: 18, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading) // Ensure text aligns to the left
                                .lineLimit(2) // Limit to two lines if necessary
                                .truncationMode(.tail)
                            Spacer()
                        }
                        
                        HStack {
                            // TODO: Add back university name
                            if let channel = courseController.cachedChannels[course.channelId!] {
                                Text(channel.title!)
                                    .lineLimit(1) // Limit to a single line
                                    .truncationMode(.tail) // Use ellipsis for truncation
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Text("\(course.numLecturesInCourse!) Lectures")
                                .font(.system(size: 14, design: .serif))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(course.watchTimeInHrs!)hrs")
                                .font(.system(size: 14, design: .serif))
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
        .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
        .shadow(radius: 2.5)
    }
}

//#Preview {
//    WatchedCourseCard(course: Course(), watchHistory: WatchHistory())
//}
