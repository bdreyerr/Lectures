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
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                    } else {
                        SkeletonLoader(width: 60, height: 60)
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
                        
                        
                        
                        // channel image
                        HStack {
                            // channel name
                            if let channel = courseController.cachedChannels[channelId] {
                                Text(channel.title ?? "")
                                    .font(.system(size: 12, design: .serif))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Text("\(numLecturesInCourse) Lectures")
                                .font(.system(size: 12))
                            //                            .font(.system(size: 12, design: .serif))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text("\(watchTimeInHrs)hr Watch Time")
                                .font(.system(size: 12))
                            //                            .font(.system(size: 12, design: .serif))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
                                .font(.system(size: 12))
                            //                            .font(.system(size: 12, design: .serif))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Spacer()
                        }
                    }
                }
                .cornerRadius(5)
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(TapGesture().onEnded {
//                courseController.focusCourse(course)
//                courseController.courseRecommendations
            })
            
            
            
//            Button(action: {
//                // if this course is the same as the focused course already do nothing
//                if let focusedCourse = courseController.focusedCourse, let focusedCourseId = focusedCourse.id, focusedCourseId == courseId {
//                    return
//                }
//                
//                courseController.focusCourse(course)
//                
//                // get the lectures in this course (we need this because this is inside course view and the re-appear won't retriger the fetch)
//                if let lectureIds = course.lectureIds {
//                    courseController.retrieveLecturesInCourse(courseId: courseId, lectureIds: lectureIds, isFetchingMore: false)
//                }
//            }) {
//                HStack {
//                    // Image
//                    if let image = courseController.courseThumbnails[courseId] {
//                        Image(uiImage: image)
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .aspectRatio(contentMode: .fill)
//                    } else {
//                        SkeletonLoader(width: 60, height: 60)
//                    }
//                    
//                    VStack {
//                        // course name
//                        HStack {
//                            Text(course.courseTitle ?? "")
//                                .font(.system(size: 16, design: .serif))
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                            Spacer()
//                        }
//                        
//                        
//                        
//                        // channel image
//                        HStack {
//                            // channel name
//                            if let channel = courseController.cachedChannels[channelId] {
//                                Text(channel.title ?? "")
//                                    .font(.system(size: 12, design: .serif))
//                                    .lineLimit(1)
//                                    .truncationMode(.tail)
//                            }
//                            
//                            Text("\(numLecturesInCourse) Lectures")
//                                .font(.system(size: 12))
//                            //                            .font(.system(size: 12, design: .serif))
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                            
//                            Text("\(watchTimeInHrs)hr Watch Time")
//                                .font(.system(size: 12))
//                            //                            .font(.system(size: 12, design: .serif))
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                            
//                            Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
//                                .font(.system(size: 12))
//                            //                            .font(.system(size: 12, design: .serif))
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                            
//                            Spacer()
//                        }
//                    }
//                }
//                .cornerRadius(5)
//            }
//            .buttonStyle(PlainButtonStyle())
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
