//
//  NewCourseTabSwitcher.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import SwiftUI
import YouTubePlayerKit

struct NewCourseTabSwitcher: View {
    @State private var selectedTab = "Lectures"
    
    var course: Course
    
    @Binding var playingLecture: Lecture?
    @Binding var isLecturePlaying: Bool
    
    var lastWatchedLectureNumber: Int?
    
    @ObservedObject var player: YouTubePlayer
    
    var body: some View {
        // Tab Switcher
        VStack(spacing: 0) {
//            Text("Current playing lecture: \(playingLecture?.id ?? "-1")" )
            // Tab buttons
            HStack(spacing: 0) {
                ForEach(["Lectures", "Resources", "About"], id: \.self) { tab in
                    Button(action: {
                        withAnimation {
                            selectedTab = tab
                        }
                    }) {
                        VStack {
                            Text(tab)
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == tab ? .primary : .gray)
//                                .padding(.vertical, 4)
                            
                            // Underline indicator
                            Rectangle()
                                .fill(selectedTab == tab ? .orange.opacity(0.8) : .clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            // Divider line
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            // Content based on selected tab
            switch selectedTab {
            case "Lectures":
                // TODO: pass in the actual last watched lecture number
                TabLectures(course: course, playingLecture: $playingLecture, isLecturePlaying: $isLecturePlaying, lastWatchedLectureNumber: lastWatchedLectureNumber, player: player)
            case "Resources":
                TabResources(course: course, playingLecture: playingLecture)
            case "About":
                TabAbout(course: course, lecture: playingLecture)
            default:
                EmptyView()
            }
        }
        .padding(.bottom, 80)
    }
}

//#Preview {
//    NewCourseTabSwitcher()
//}
