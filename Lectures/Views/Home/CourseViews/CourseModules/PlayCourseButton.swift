//
//  PlayCourseButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/9/25.
//

import SwiftUI

struct PlayCourseButton: View {
    @EnvironmentObject var homeController: HomeController
    
    // Youtube player
    @EnvironmentObject var youTubePlayerController: YouTubePlayerController
    
    @Binding var shouldPopCourseFromStack: Bool
    
    var lecture: Lecture
    var body: some View {
        
        NavigationLink(destination: LectureView()) {
            HStack(spacing: 8) {
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white)
                
                Text("Play")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(Color.red)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.red, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded {
            // make a course up
            print("clicked on a lecture in course view")
            homeController.focusLecture(lecture)
            
            // change the YT player source url
            youTubePlayerController.changeSource(url: lecture.youtubeVideoUrl ?? "")
            
            // don't pop the course from the stack
            shouldPopCourseFromStack = false
        })
    }
}

#Preview {
    PlayCourseButton(shouldPopCourseFromStack: .constant(false), lecture: Lecture())
        .environmentObject(HomeController())
        .environmentObject(YouTubePlayerController())
}
