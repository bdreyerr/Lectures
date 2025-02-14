//
//  LectureCardView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct LectureCardView: View {
    @EnvironmentObject var courseController: CourseController
    
    var lecture: Lecture
    var body: some View {
        Group {
            if let id = lecture.id, let lectureTitle = lecture.lectureTitle, let channelId = lecture.channelId {
                ZStack(alignment: .bottomLeading) {
                    if let image = courseController.lectureThumbnails[id] {
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
                    
                    // Play button overlay in center
                    Image(systemName: "play.circle.fill") // SF Symbol for play button
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make frame fill available space
                        .allowsHitTesting(false) // Prevent play button from blocking other interactions
                    
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(lectureTitle)
                                        .font(.system(size: 14, design: .serif))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading) // Ensure text aligns to the left
                                        .lineLimit(2) // Limit to two lines if necessary
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                
                                HStack {
                                    if let channel = courseController.cachedChannels[channelId] {
                                        if let title = channel.title {
                                            Text(title)
                                                .lineLimit(1) // Limit to a single line
                                                .truncationMode(.tail) // Use ellipsis for truncation
                                                .font(.system(size: 11, design: .serif))
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                    }
                                    
                                    // TODO: add duration
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
        .onAppear {
            // We need to fetch the relevant course in case the user wants to tap this lecture and watch it
            if let courseId = lecture.courseId {
                courseController.retrieveCourse(courseId: courseId)
            }
            
            // also get lecture thumbnail if not already there
            if let id = lecture.id {
                courseController.getLectureThumnbnail(lectureId: id)
            }
        }
    }
}

//#Preview {
//    LectureCardView()
//}
