//
//  CuratedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct CuratedCourses: View {
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Curated Courses")
                .font(.system(size: 20, design: .serif))
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    NavigationLink(destination: CourseView()) {
                        FeaturedCourse(image: "mit", courseTitle: "Society of Mind", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CourseView()) {
                        FeaturedCourse(image: "mit2", courseTitle: "Computer Science", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CourseView()) {
                        FeaturedCourse(image: "stanford", courseTitle: "Sociology I", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    CuratedCourses()
}
