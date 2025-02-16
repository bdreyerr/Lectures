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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var courseId: String
    
    var body: some View {
        if let course = courseController.cachedCourses[courseId], 
           let courseTitle = course.courseTitle, 
           let numLecturesInCourse = course.numLecturesInCourse, 
           let watchTimeInHrs = course.watchTimeInHrs, 
           let aggregateViews = course.aggregateViews {
            
            HStack {
                // Image
                if let image = courseController.courseThumbnails[courseId] {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: thumbnailWidth, height: thumbnailHeight)
                        .clipped()
                } else {
                    SkeletonLoader(width: thumbnailWidth, height: thumbnailHeight)
                }
                
                // Lecture Name
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(height: textContainerHeight)
                    .overlay {
                        VStack(alignment: .leading) {
                            Text(courseTitle)
                                .font(.system(size: titleFontSize, design: .serif))
                                .lineLimit(3)
                                .truncationMode(.tail)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text("\(numLecturesInCourse) Lectures")
                                    .font(.system(size: subtitleFontSize))
                                    .opacity(0.8)
                                
                                Text("\(watchTimeInHrs)Hrs")
                                    .font(.system(size: subtitleFontSize))
                                    .opacity(0.8)
                                
                                Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
                                    .font(.system(size: subtitleFontSize))
                                    .opacity(0.8)
                                
                                Spacer()
                            }
                        }
                    }
            }
            .cornerRadius(5)
        }
    }
    
    // Computed properties for responsive sizing
    private var thumbnailWidth: CGFloat {
        horizontalSizeClass == .regular ? 160 : 120
    }
    
    private var thumbnailHeight: CGFloat {
        thumbnailWidth * 0.5625 // Maintains 16:9 aspect ratio
    }
    
    private var textContainerHeight: CGFloat {
        horizontalSizeClass == .regular ? 50 : 40
    }
    
    private var titleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 16 : 13
    }
    
    private var subtitleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 13 : 11
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
