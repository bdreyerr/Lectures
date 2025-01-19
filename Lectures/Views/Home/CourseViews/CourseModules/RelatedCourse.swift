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
        Button(action: {
            // if this course is the same as the focused course already do nothing
            if let focusedCourse = courseController.focusedCourse, focusedCourse.id == course.id {
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
                courseController.retrieveLecturesInCourse(courseId: course.id!, lectureIds: lectureIds)
            }
        }) {
            HStack {
                // Image
                if let image = courseController.courseThumbnails[course.id!] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image("google_logo")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fill)
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
                        if let channel = courseController.cachedChannels[course.channelId!] {
                            Text(channel.title ?? "")
                                .font(.system(size: 12, design: .serif))
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        
                        Text("\(course.numLecturesInCourse ?? 0) Lectures")
                            .font(.system(size: 12))
//                            .font(.system(size: 12, design: .serif))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Text("\(course.watchTimeInHrs ?? 0)r Watch Time")
                            .font(.system(size: 12))
//                            .font(.system(size: 12, design: .serif))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Text("\(course.aggregateViews ?? "0") Views")
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

#Preview {
    RelatedCourse(course: Course())
        .environmentObject(HomeController())
}
