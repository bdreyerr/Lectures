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
        if let courseId = course.id, let courseTitle = course.courseTitle, let numLecturesInCourse = course.numLecturesInCourse, let watchTimeInHrs = course.watchTimeInHrs, let aggregateViews = course.aggregateViews, let categories = course.categories {
            
            NavigationLink(destination: CourseView()) {
                HStack {
                    if let image = courseController.courseThumbnails[courseId] {
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
                            Text(courseTitle)
                                .font(.system(size: 16, design: .serif))
                                .bold()
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            
                            Spacer()
                        }
                        
                        
                        HStack {
                            Text("\(numLecturesInCourse) Lectures")
                                .font(.system(size: 12))
                                .opacity(0.6)
                            
                            Text("\(watchTimeInHrs)hrs")
                                .font(.system(size: 12))
                                .opacity(0.6)
                            
                            Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
                                .font(.system(size: 12))
                                .opacity(0.6)
                            Spacer()
                        }
                        .lineLimit(1)
                        .truncationMode(.tail)
                        
                        HStack {
                            Text(categories[0])
                                .font(.system(size: 12))
                                .opacity(0.6)
                            
                            Spacer()
                        }
                        .lineLimit(1)
                        .truncationMode(.tail)
                    }
                }
            }
            .frame(maxWidth: 280)
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(TapGesture().onEnded { _ in
                courseController.focusCourse(course)
            })
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

//#Preview {
//    CourseSearchResult()
//}
