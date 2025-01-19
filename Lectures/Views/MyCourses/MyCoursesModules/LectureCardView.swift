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
        ZStack(alignment: .bottomLeading) {
            if let image = courseController.lectureThumbnails[lecture.id!] {
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
            
            // Play button overlay in center
            Circle()
                .fill(.black.opacity(0.6))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "play.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                )
                .position(x: UIScreen.main.bounds.width * 0.3, y: 75) // Center of the card
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(lecture.lectureTitle!)
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
                            if let channel = courseController.cachedChannels[lecture.channelId!] {
                                Text(channel.title!)
                                    .lineLimit(1) // Limit to a single line
                                    .truncationMode(.tail) // Use ellipsis for truncation
                                    .font(.system(size: 14, design: .serif))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
//                            Text("\(course.numLecturesInCourse!) Lectures")
//                                .font(.system(size: 14, design: .serif))
//                                .foregroundColor(.white.opacity(0.8))
//                            Text("\(course.watchTimeInHrs!)hrs")
//                                .font(.system(size: 14, design: .serif))
//                                .foregroundColor(.white.opacity(0.8))
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

//#Preview {
//    LectureCardView()
//}
