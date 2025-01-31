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
            Button(action: {
                // if this course is the same as the focused course already do nothing
                if let focusedCourse = courseController.focusedCourse, let focusedCourseId = focusedCourse.id, focusedCourseId == courseId {
                    return
                }
                
                courseController.focusCourse(course)
                
                // fetch exam, exam answers and lectures in course - this is normally in the on appear of CourseView, but when hitting a related course the courseview doesn't dissapear and reappear
                
                // get the exam
                if let examId = course.examResourceId {
                    examController.retrieveExam(examId: examId)
                } else {
                    print("course didn't have an exam Id")
                }
                
                // get the exam answers
                if let examAnswerId = course.examAnswersResourceId {
                    examAnswerController.retrieveExamAnswer(examAnswerId: examAnswerId)
                } else {
                    print("course didn't have an exam Id")
                }
                
                // get the lectures in this course
                if let lectureIds = course.lectureIds {
                    courseController.retrieveLecturesInCourse(courseId: courseId, lectureIds: lectureIds)
                }
            }) {
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
