//
//  NewLectureView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct CourseCardView: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    
    var course: Course
    var body: some View {
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
                    // default image when not loaded
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 130)
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
                            Text(courseTitle)
                                .font(.system(size: 14, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack {
                                // TODO: Add back university name
                                if let channel = courseController.cachedChannels[channelId], let channelTitle = channel.title {
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
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.6, height: 130)
        }
    }
}

#Preview {
    CourseCardView(course: Course())
        .environmentObject(HomeController())
}
