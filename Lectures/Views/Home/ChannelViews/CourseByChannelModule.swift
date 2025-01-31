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
                                Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
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
    
    func formatIntViewsToString(numViews: Int) -> String {
        switch numViews {
            case 0..<1_000:
                return String(numViews)
            case 1_000..<1_000_000:
                let thousands = Double(numViews) / 1_000.0
                return String(format: "%.0fk", thousands)
            case 1_000_000...:
                let millions = Double(numViews) / 1_000_000.0
                return String(format: "%.0fM", millions)
            default:
                return "0"
            }
    }
}

#Preview {
    CourseByChannelModule(courseId: "1")
}
