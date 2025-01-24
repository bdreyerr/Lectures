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
                            Text(courseTitle)
                                .font(.system(size: 18, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack {
                                // TODO: Add back university name
                                if let channel = courseController.cachedChannels[channelId], let channelTitle = channel.title {
                                    Text(channelTitle)
                                        .lineLimit(1) // Limit to a single line
                                        .truncationMode(.tail) // Use ellipsis for truncation
                                        .font(.system(size: 14, design: .serif))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Text("\(numLecturesInCourse) Lectures")
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(.white.opacity(0.8))
                                Text("\(watchTimeInHrs)hrs")
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
                .padding(.bottom, 1)
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
            .shadow(radius: 2.5)
        }
    }
}

#Preview {
    CourseCardView(course: Course())
        .environmentObject(HomeController())
}
