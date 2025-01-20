//
//  CourseSearchResult.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/19/25.
//

import SwiftUI

struct CourseSearchResult: View {
    @EnvironmentObject var courseController: CourseController
    
    var course: Course
    
    var body: some View {
        NavigationLink(destination: CourseView()) {
            HStack {
                if let image = courseController.courseThumbnails[course.id!] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 120, height: 67.5)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(5)
                } else {
                    // default image when not loaded
                    SkeletonLoader(width: 120, height: 67.5)
                }
                
                VStack {
                    HStack {
                        Text(course.courseTitle!)
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        
                        Spacer()
                    }
                    
                    
                    HStack {
                        Text("\(course.numLecturesInCourse!) Lectures")
                            .font(.system(size: 12))
                            .opacity(0.6)
                        
                        Text("\(course.watchTimeInHrs!)hrs")
                            .font(.system(size: 12))
                            .opacity(0.6)
                        
                        Text("\(course.aggregateViews!) Views")
                            .font(.system(size: 12))
                            .opacity(0.6)
                        Spacer()
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    
                    HStack {
                        Text(course.categories![0])
                            .font(.system(size: 12))
                            .opacity(0.6)
                        
                        Spacer()
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                }
            }
        }
        .frame(maxWidth: 330, maxHeight: 100)
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded { _ in
            courseController.focusCourse(course)
        })
    }
    
}

//#Preview {
//    CourseSearchResult()
//}
