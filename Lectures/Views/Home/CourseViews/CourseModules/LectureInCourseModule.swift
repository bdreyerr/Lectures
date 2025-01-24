//
//  LectureInCourseModule.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import SwiftUI

struct LectureInCourseModule: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var lecture: Lecture
    
    var body: some View {
        if let lectureId = lecture.id {
            // Other Lectures in the course
            HStack {
                // Image
                if let image = courseController.lectureThumbnails[lectureId] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fill)
                    
                    // Lecture Name
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .frame(height: 40)
                        .overlay {
                            HStack {
                                Text(lecture.lectureTitle ?? "Lecture Title")
                                    .font(.system(size: 14, design: .serif))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                                
                                // Lecture Number
                                Text(toRoman(lecture.lectureNumberInCourse ?? 1))
                                    .font(.system(size: 14, design: .serif))
                                    .padding(.trailing, 20)
                            }
                        }
                    
                } else {
                    HStack {
                        SkeletonLoader(width: 300, height: 40)
                        Spacer()
                    }
                }
                
                
            }
            .cornerRadius(5)
        }
    }
    
    func toRoman(_ num: Int) -> String {
        let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let numerals = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var result = ""
        var number = num
        
        for (index, value) in values.enumerated() {
            while number >= value {
                result += numerals[index]
                number -= value
            }
        }
        
        return result
    }
}

#Preview {
    LectureInCourseModule(lecture: Lecture())
        .environmentObject(HomeController())
}
