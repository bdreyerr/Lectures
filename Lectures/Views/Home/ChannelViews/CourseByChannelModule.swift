//
//  CourseByChannelModule.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct CourseByChannelModule: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var courseId: String
    var body: some View {
        if let course = courseController.cachedCourses[courseId] {
            // Other Lectures in the course
            HStack {
                // Image
                
                if let image = courseController.courseThumbnails[courseId] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("google_logo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fill)
                }
                
                // Lecture Name
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(height: 40)
                    .overlay {
                        VStack {
                            HStack {
                                Text(course.courseTitle ?? "Course Title")
                                    .font(.system(size: 14, design: .serif))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                            }
                            
                            HStack {
                                // num Lectures
                                Text("\(course.numLecturesInCourse!) Lectures")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                                
                                
                                // Watch time
                                Text("\(course.watchTimeInHrs!)Hrs")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                                
                                // Views
                                Text("\(course.aggregateViews!) Views")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                                
                                Spacer()
                            }
                            
                        }
                    }
            }
            .cornerRadius(5)
        }
    }
}

#Preview {
    CourseByChannelModule(courseId: "1")
}
