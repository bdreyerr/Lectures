//
//  LecturesInCourse.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/28/24.
//

import SwiftUI

struct LecturesInCourse: View {
    var images = ["stanford", "mit", "stanford", "mit"]
    var lectures = ["II. The Science of Cognition", "III. Whatever the Fuck", "IV. Anything Else", "V. Finally"]
    var lectureNumbers = ["II", "III", "IV", "V"]
    var loopLol  = [0,1,2,3]
    var body: some View {
        VStack {
            HStack {
                Text("Lectures In")
                    .font(.system(size: 14, design: .serif))
                    .bold()
                
                Text("The Emotion Machine")
                    .font(.system(size: 14, design: .serif))
                
                Spacer()
            }
            
            Group {
                NavigationLink(destination: LectureView()) {
                    LectureInCourseModule(image: images[0],lectureName: lectures[0], lectureNumber: lectureNumbers[0])
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: LectureView()) {
                    LectureInCourseModule(image: images[1], lectureName: lectures[1], lectureNumber: lectureNumbers[1])
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: LectureView()) {
                    LectureInCourseModule(image: images[2], lectureName: lectures[2], lectureNumber: lectureNumbers[2])
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: LectureView()) {
                    LectureInCourseModule(image: images[3], lectureName: lectures[3], lectureNumber: lectureNumbers[3])
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct LectureInCourseModule: View {
    var image: String
    var lectureName: String
    var lectureNumber: String
    var body: some View {
        // Other Lectures in the course
        HStack {
            // Image
            Image(image)
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(contentMode: .fill)
            
            // Lecture Name
            Rectangle()
                .foregroundColor(Color.clear)
                .frame(height: 40)
                .overlay {
                    HStack {
                        Text(lectureName)
                            .font(.system(size: 14, design: .serif))
                        
                        Spacer()
                        
                        // Lecture Number
                        Text(lectureNumber)
                            .font(.system(size: 14, design: .serif))
                            .padding(.trailing, 20)
                    }
                }
        }
        .cornerRadius(5)
    }
}

#Preview {
    LecturesInCourse()
}
