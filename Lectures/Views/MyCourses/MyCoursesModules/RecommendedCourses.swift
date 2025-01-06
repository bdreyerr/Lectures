//
//  RecommendedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct RecommendedCourses: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recommended For You")
                    .font(.system(size: 20, design: .serif))
                    .bold()
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    RecommendedCourses()
}
