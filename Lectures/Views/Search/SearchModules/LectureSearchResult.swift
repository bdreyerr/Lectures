//
//  LectureSearchResult.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/19/25.
//

import SwiftUI

struct LectureSearchResult: View {
    @EnvironmentObject var courseController: CourseController
    
    var lecture: Lecture
    
    var body: some View {
        NavigationLink(destination: LectureView()) {
            HStack {
                ZStack {
                    if let image = courseController.lectureThumbnails[lecture.id!] {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 120, height: 67.5)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(5)
                    } else {
                        // default image when not loaded
                        SkeletonLoader(width: 120, height: 67.5)
                    }
                    
                    Image(systemName: "play.circle.fill") // SF Symbol for play button
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                
                VStack {
                    HStack {
                        Text(lecture.lectureTitle!)
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                    }
                    
                    HStack {
                        // TODO: add a field course name on the lecture object
                        Text("Lecture # \(lecture.lectureNumberInCourse!) in The Emotion Machine")
                            .font(.system(size: 12))
                            .opacity(0.6)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                    }
                    
                    
                    HStack {
                        Text("\(lecture.viewsOnYouTube!) Views")
                            .font(.system(size: 12))
                            .opacity(0.6)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: 330, maxHeight: 100)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded { _ in
            courseController.focusLecture(lecture)
        })
    }
}

//#Preview {
//    LectureSearchResult()
//}
