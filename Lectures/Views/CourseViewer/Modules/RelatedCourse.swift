//
//  RelatedCourse.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/7/25.
//

import SwiftUI

struct RelatedCourse: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    @EnvironmentObject var examController: ExamController
    @EnvironmentObject var examAnswerController: ExamAnswerController
    
    var course: Course
    var body: some View {
        if let courseId = course.id, let channelId = course.channelId, let numLecturesInCourse = course.numLecturesInCourse, let watchTimeInHrs = course.watchTimeInHrs, let aggregateViews = course.aggregateViews  {
            NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                HStack {
                    // Image
                    if let image = courseController.courseThumbnails[courseId] {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill) // Fill the frame while maintaining aspect ratio
                            .frame(width: 60, height: 40)
                            .clipped() // Clip the image to the frame
                    } else {
                        SkeletonLoader(width: 60, height: 40)
                    }
                    
                    VStack {
                        // course name
                        HStack {
                            Text(course.courseTitle ?? "")
                                .font(.system(size: 16, design: .serif))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                        
                        HStack {
                            // channel name
                            if let channel = courseController.cachedChannels[channelId] {
                                Text(channel.title ?? "")
                                    .font(.system(size: 12, design: .serif))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Spacer()
                        }
                        
                        // Course Info
                        HStack {
                            Text("\(numLecturesInCourse) Lectures")
                                .font(.system(size: 12))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text("\(watchTimeInHrs)hr Watch Time")
                                .font(.system(size: 12))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
                                .font(.system(size: 12))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                    }
                    .padding(.leading, 5)
                }
                .cornerRadius(5)
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(TapGesture().onEnded {
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

#Preview {
    RelatedCourse(course: Course())
        .environmentObject(HomeController())
}
