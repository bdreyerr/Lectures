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
        if let course = courseController.cachedCourses[courseId], let courseTitle = course.courseTitle, let numLecturesInCourse = course.numLecturesInCourse, let watchTimeInHrs = course.watchTimeInHrs, let aggregateViews = course.aggregateViews {
            // Other Lectures in the course
            HStack {
                // Image
                
                if let image = courseController.courseThumbnails[courseId] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .aspectRatio(contentMode: .fill)
                } else {
                    SkeletonLoader(width: 40, height: 40)
                }
                
                // Lecture Name
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(height: 40)
                    .overlay {
                        VStack {
                            HStack {
                                Text(courseTitle)
                                    .font(.system(size: 14, design: .serif))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Spacer()
                            }
                            
                            HStack {
                                // num Lectures
                                Text("\(numLecturesInCourse) Lectures")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                                
                                
                                // Watch time
                                Text("\(watchTimeInHrs)Hrs")
                                    .font(.system(size: 12))
                                    .opacity(0.8)
                                
                                // Views
                                Text("\(aggregateViews) Views")
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
