//
//  WatchedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct WatchedCourses: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Watched Courses")
                    .font(.system(size: 20, design: .serif))
                    .bold()
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    NavigationLink(destination: CourseView()) {
//                        FeaturedCourse(image: "mit", courseTitle: "Society of Mind", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                        NewLectureView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CourseView()) {
                        NewLectureView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CourseView()) {
                        NewLectureView()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    WatchedCourses()
}
