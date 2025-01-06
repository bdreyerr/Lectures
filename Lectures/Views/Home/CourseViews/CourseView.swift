//
//  CourseView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var examController: ExamController
    @EnvironmentObject var examAnswerController: ExamAnswerController
    

    @State var isCourseLiked: Bool = false
    @State private var isChannelFollowed = false
    
    var body: some View {
        if let course = homeController.focusedCourse {
            VStack {
                // Course Cover Image?
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        HStack {
                            // Course title and University
                            VStack {
                                Text(course.courseTitle ?? "")
                                    .font(.system(size: 18, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                
                                // nav link to channel view
//                                NavigationLink(destination: ChannelView()) {
//                                    
//                                }
//                                .simultaneousGesture(TapGesture().onEnded {
//                                    // focus a channel
//                                    if let channel = homeController.cachedChannels[course.channelId!] {
//                                        homeController.focusChannel(channel)
//                                    }
//                                })
//                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Save button
                            if !isCourseLiked {
                                Image(systemName: "heart")
                                    .font(.system(size: 18, design: .serif))
                                    .onTapGesture {
                                        self.isCourseLiked.toggle()
                                    }
                            } else {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundStyle(Color.red)
                                    .onTapGesture {
                                        self.isCourseLiked.toggle()
                                    }
                            }
                        }
                        
                        // Course Info
                        HStack {
                            Text("\(course.numLecturesInCourse ?? 1) Lectures")
                                .font(.system(size: 12, design: .serif))
                                .opacity(0.6)
                            
                            Text("\(course.watchTimeInHrs ?? 1)Hr Watch Time")
                                .font(.system(size: 12, design: .serif))
                                .opacity(0.6)
                            
                            Text("\(course.aggregateViews ?? "0") Views")
                                .font(.system(size: 12, design: .serif))
                                .opacity(0.6)
                            Spacer()
                        }
                        
                        // Course Categories
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(course.categories ?? [], id: \.self) { category in
                                    Text(category)
                                        .font(.system(size: 12, design: .serif))
                                        .opacity(0.6)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        // Channel Info
                        HStack {
                            // channel image - nav link to channel view
                            NavigationLink(destination: ChannelView()) {
                                if let channelImage = homeController.channelThumbnails[course.channelId!] {
                                    Image(uiImage: channelImage)
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .frame(width: 40, height: 40)
                                } else {
                                    Image("stanford")
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .frame(width: 40, height: 40)
                                }
                                
                                if let channel = homeController.cachedChannels[course.channelId!] {
                                    VStack {
                                        Text(channel.title!)
                                            .font(.system(size: 14, design: .serif))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        HStack {
                                            Text("\(channel.numCourses!) Courses")
                                                .font(.system(size: 12, design: .serif))
                                                .opacity(0.6)
                                            
                                            Text("\(channel.numLectures!) Lectures")
                                                .font(.system(size: 12, design: .serif))
                                                .opacity(0.6)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                // focus a channel
                                // try to get the channel using course.channelId
                                if let channel = homeController.cachedChannels[course.channelId!] {
                                    homeController.focusChannel(channel)
                                }
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            // Channel Follow Button
                            // follow button
                            Button(action: {
                                withAnimation(.spring()) {
                                    isChannelFollowed.toggle()
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: isChannelFollowed ? "heart.fill" : "heart")
                                        .font(.system(size: 14))
                                    
                                    Text(isChannelFollowed ? "Following" : "Follow")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .foregroundColor(isChannelFollowed ? .white : .primary)
                                .background(
                                    Capsule()
                                        .fill(isChannelFollowed ? Color.red : Color.clear)
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(isChannelFollowed ? Color.red : Color.gray, lineWidth: 1)
                                        )
                                )
                            }
                        }
                        
                        // Course Description
                        ExpandableText(text: course.courseDescription!, maxLength: 150)
                            .padding(.top, 1)
                        
                        
                        // Exam
                        
                        HStack {
                            Text("Exam")
                                .font(.system(size: 14, design: .serif))
                                .bold()
                            Image(systemName: "sparkles")
                                .foregroundStyle(Color.blue)
                                .font(.system(size: 14, design: .serif))
                            Spacer()
                        }
                        .padding(.top, 2)
                        
                        
                        if let examId = course.examResourceId {
                            if let exam = examController.cachedExams[examId] {
                                ResourceChip(resource: exam)
                            }
                        }
                        
                        // todo put a loading thing here or something to indicate there's no resource on this
                        
                        
                        
                        // Exam Answers
                        HStack {
                            Text("Exam Answers")
                                .font(.system(size: 14, design: .serif))
                                .bold()
                            Image(systemName: "sparkles")
                                .foregroundStyle(Color.blue)
                                .font(.system(size: 14, design: .serif))
                            Spacer()
                        }
                        .padding(.top, 2)
                        
                        if let examAnswerId = course.examAnswersResourceId {
                            if let examAnswer = examAnswerController.cachedExamAnswers[examAnswerId] {
                                ResourceChip(resource: examAnswer)
                            }
                        }
                        
                        // todo put a loading thing here or something to indicate there's no resource on this
                        
                        LecturesInCourse(course: course)
                            .padding(.top, 20)
                            .padding(.bottom, 100)
                        
                        Divider()
                        
                        
                        // Related Courses
                        HStack {
                            Text("Related to")
                                .font(.system(size: 14, design: .serif))
                                .bold()
                            
                            Text("The Emotion Machine")
                                .font(.system(size: 14, design: .serif))
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    NavigationLink(destination: CourseView()){
                        SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "Swaginomics", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        // make a course up
                        let course = Course(id: "1", channelId: "1", courseTitle: "the title is here", courseDescription: "description is here", professorName: "Jimmy", numLecturesInCourse: 2, watchTimeInHrs: 5, categories: [], examResourceId:"1", examAnswersResourceId: "1")
                        homeController.focusCourse(course)
                    })
                    
//                    SearchedCourse(coverImage: "stanford", universityImage: "mit", courseName: "How to pull", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
//                    
//                    SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "Another One For Ya", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                }
            }
            .onAppear {
                // get resource info
                
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
                    homeController.retrieveLecturesInCourse(courseId: course.id!, lectureIds: lectureIds)
                }
            }
        }
    }
    
}

#Preview {
    CourseView()
        .environmentObject(HomeController())
        .environmentObject(ExamController())
        .environmentObject(ExamAnswerController())
}
