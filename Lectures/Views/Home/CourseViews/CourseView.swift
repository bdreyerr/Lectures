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
        // else view is loaded
        if let course = homeController.focusedCourse {
            VStack {
                // Course Cover Image?
                ScrollView(showsIndicators: false) {
                    
                    
                    VStack(spacing: 5) {
                        HStack {
                            // Course title and University
                            VStack {
                                Text(course.courseTitle ?? "")
                                    .font(.system(size: 18, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
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
                        
                        HStack {
                            // Play Button - links to lecture view and starts video
                            if let lectures = homeController.lecturesInCourse[course.id!] {
                                if lectures.count > 0 {
                                    PlayCourseButton(lecture: lectures[0])
                                } else {
                                    Text("No first lecture")
                                }
                            } else {
                                Text("no lectures list")
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 4)
                        
                       
                        
                        // Channel Info
                        HStack {
                            // channel image - nav link to channel view
                            NavigationLink(destination: ChannelView()) {
                                if let channelImage = homeController.channelThumbnails[course.channelId!] {
                                    Image(uiImage: channelImage)
                                        .resizable()
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .frame(width: 40, height: 40)
                                    
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
                                        
                                        // Channel Follow Button
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
                                } else {
                                    HStack {
                                        SkeletonLoader(width: 300, height: 40)
                                        Spacer()
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
                        }
                        .cornerRadius(5)
                        
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
                            } else {
                                HStack {
                                    SkeletonLoader(width: 300, height: 40)
                                    Spacer()
                                }
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
                            } else {
                                HStack {
                                    SkeletonLoader(width: 300, height: 40)
                                    Spacer()
                                }
                            }
                        }
                        
                        // todo put a loading thing here or something to indicate there's no resource on this
                        LecturesInCourse(course: course)
                            .padding(.top, 20)
                            .padding(.bottom, 50)
                        
                        
                        Divider()
                            .padding(.bottom, 20)
                        
                        
                        // Related Courses
                        HStack {
                            Text("Courses related to")
                                .font(.system(size: 14, design: .serif))
                                .bold()
                            
                            
                            Text(course.courseTitle ?? "")
                                .font(.system(size: 14, design: .serif))
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Spacer()
                        }
                        
                        Group {
                            ForEach(homeController.communityFavorites, id: \.id) { course in
                                RelatedCourse(course: course)
                            }
                        }
                        
                        // Logo
                        if (colorScheme == .light) {
                            Image("LogoTransparentWhiteBackground")
                                .resizable()
                                .frame(width: 80, height: 80)
                        } else if (colorScheme == .dark) {
                            Image("LogoBlackBackground")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        Text("Lectura")
                            .font(.system(size: 15, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .opacity(0.8)
                        Text("version 1.1")
                            .font(.system(size: 11, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .opacity(0.8)
                    }
                    .padding(.horizontal, 20)
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
        .environmentObject(YouTubePlayerController())
}
