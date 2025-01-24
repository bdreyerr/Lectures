//
//  CourseView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var examController: ExamController
    @EnvironmentObject var examAnswerController: ExamAnswerController
    // Youtube player
//    @EnvironmentObject var youTubePlayerController: YouTubePlayerController
    
    // TODO: move these into user controller rather than local on this view
    @State var isCourseLiked: Bool = false
    @State private var isChannelFollowed = false
    
    @State private var shouldPopCourseFromStackOnDissapear: Bool = true
    @State private var shouldAddCourseToStack: Bool = true
    
    @State private var isUpgradeAccountSheetShowing: Bool = false
    
    var body: some View {
        Group {
            if let course = courseController.focusedCourse, let courseId = course.id, let channelId = course.channelId, let courseDescription = course.courseDescription {
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
                                

                                // Like Course Button
                                Button(action: {
                                    // if the user isn't a PRO member, they can't like courses
                                    if let user = userController.user, let userId = user.id {
                                        if user.accountType == 1 {
                                            if let rateLimit = rateLimiter.processWrite() {
                                                print(rateLimit)
                                                return
                                            }
                                            
                                            userController.likeCourse(userId: userId, courseId: courseId)
                                            withAnimation(.spring()) {
                                                self.isCourseLiked.toggle()
                                            }
                                            // TODO: add logic to like a course
                                            return
                                        }
                                    }
                                    
                                    // show the upgrade account sheet
                                    self.isUpgradeAccountSheetShowing = true
                                }) {
                                    Image(systemName: isCourseLiked ? "heart.fill" : "heart")
                                        .font(.system(size: 18, design: .serif))
                                        .foregroundStyle(isCourseLiked ? Color.red : colorScheme == .light ? Color.black : Color.white)
                                }
                                
                            }
                            
                            // Course Info
                            HStack {
                                Text("\(course.numLecturesInCourse ?? 1) Lectures")
                                    .font(.system(size: 12))
//                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                
                                Text("\(course.watchTimeInHrs ?? 1)Hr Watch Time")
                                    .font(.system(size: 12))
//                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                
                                Text("\(course.aggregateViews ?? "0") Views")
                                    .font(.system(size: 12))
//                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                Spacer()
                            }
                            
                            // Course Categories
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(course.categories ?? [], id: \.self) { category in
                                        Text(category)
                                            .font(.system(size: 12))
//                                            .font(.system(size: 12, design: .serif))
                                            .opacity(0.6)
                                    }
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                // Play Button - links to lecture view and starts video
                                if let lectures = courseController.lecturesInCourse[courseId] {
                                    if lectures.count > 0 {
                                        PlayCourseButton(shouldPopCourseFromStack: $shouldPopCourseFromStackOnDissapear, lecture: lectures[0])
                                    } else {
                                        Text("No first lecture")
                                    }
                                } else {
                                    Text("no lectures list")
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            
                            
                            
                            // Channel Info
                            HStack {
                                // channel image - nav link to channel view
                                NavigationLink(destination: ChannelView()) {
                                    if let channelImage = courseController.channelThumbnails[channelId] {
                                        Image(uiImage: channelImage)
                                            .resizable()
                                        //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .frame(width: 40, height: 40)
                                        
                                        if let channel = courseController.cachedChannels[channelId], let channelTitle = channel.title, let numCourses = channel.numCourses, let numLectures = channel.numLectures {
                                            VStack {
                                                Text(channelTitle)
                                                    .font(.system(size: 14, design: .serif))
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                HStack {
                                                    Text("\(numCourses) Courses")
                                                        .font(.system(size: 12))
//                                                        .font(.system(size: 12, design: .serif))
                                                        .opacity(0.6)
                                                    
                                                    Text("\(numLectures) Lectures")
                                                        .font(.system(size: 12))
//                                                        .font(.system(size: 12, design: .serif))
                                                        .opacity(0.6)
                                                    
                                                    Spacer()
                                                }
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
                                    self.shouldPopCourseFromStackOnDissapear = false
                                    
                                    // try to get the channel using course.channelId
                                    if let channel = courseController.cachedChannels[channelId] {
                                        courseController.focusChannel(channel)
                                    }
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                                // Channel Follow Button
                                Button(action: {
                                    // if the user isn't a PRO member, they can't follow accounts
                                    if let user = userController.user, let userId = user.id {
                                        if user.accountType == 1 {
                                            if let rateLimit = rateLimiter.processWrite() {
                                                print(rateLimit)
                                                return
                                            }
                                            
                                            userController.followChannel(userId: userId, channelId: channelId)
                                            withAnimation(.spring()) {
                                                isChannelFollowed.toggle()
                                            }
                                        } else {
                                            // show the upgrade account sheet
                                            self.isUpgradeAccountSheetShowing = true
                                        }
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
                            .cornerRadius(5)
                            
                            // Course Description
                            ExpandableText(text: courseDescription, maxLength: 150)
                                .padding(.top, 10)
                            
                            
                            // Exam
                            
                            HStack {
                                Text("Exam")
                                    .font(.system(size: 14))
//                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 14, design: .serif))
                                Spacer()
                            }
                            .padding(.top, 20)
                            
                            
                            if let examId = course.examResourceId {
                                if let exam = examController.cachedExams[examId] {
                                    ResourceChip(resource: exam, shouldPopFromStack: $shouldPopCourseFromStackOnDissapear)
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
                                    .font(.system(size: 14))
//                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 14, design: .serif))
                                Spacer()
                            }
                            .padding(.top, 2)
                            
                            if let examAnswerId = course.examAnswersResourceId {
                                if let examAnswer = examAnswerController.cachedExamAnswers[examAnswerId] {
                                    ResourceChip(resource: examAnswer, shouldPopFromStack: $shouldPopCourseFromStackOnDissapear)
                                } else {
                                    HStack {
                                        SkeletonLoader(width: 300, height: 40)
                                        Spacer()
                                    }
                                }
                            }
                            
                            // todo put a loading thing here or something to indicate there's no resource on this
//                            LecturesInCourse(course: course)
//                                .padding(.top, 20)
//                                .padding(.bottom, 50)
                            
                            // Lectures In Course
                            VStack {
                                HStack {
                                    Text("Lectures In")
                                        .font(.system(size: 14))
//                                        .font(.system(size: 14, design: .serif))
                                        .bold()
                                    
                                    Text(course.courseTitle ?? "Title")
                                        .font(.system(size: 14, design: .serif))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Spacer()
                                }
                                
                                Group {
                                    if let lectures = courseController.lecturesInCourse[courseId] {
                                        ForEach(lectures, id: \.id) { lecture in
                                            NavigationLink(destination: LectureView()) {
                                                LectureInCourseModule(lecture: lecture)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .simultaneousGesture(TapGesture().onEnded {
                                                shouldPopCourseFromStackOnDissapear = false
                                                // focus the lecture
                                                courseController.focusLecture(lecture)
                                            })
                                        }
                                    } else {
                                        HStack {
                                            SkeletonLoader(width: 300, height: 40)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 50)
                            
                            
                            Divider()
                                .padding(.bottom, 20)
                            
                            
                            // Related Courses
                            HStack {
                                Text("Courses related to")
                                    .font(.system(size: 14))
//                                    .font(.system(size: 14, design: .serif))
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
                            
                            BottomBrandView()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                    UpgradeAccountPaywallWithoutFreeTrial()
                }
                .onAppear {
                    // check if the user follows the course's channel and set the button accordingly
                    if let user = userController.user, let followedChannelIds = user.followedChannelIds {
                        if followedChannelIds.contains(channelId) {
                            self.isChannelFollowed = true
                        }
                    }
                    
                    // same if the user likes the course
                    if let user = userController.user, let likedCourseIds = user.likedCourseIds {
                        if likedCourseIds.contains(courseId) {
                            self.isCourseLiked = true
                        }
                    }
                    
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
                        print("retrieving lectures in course gang")
                        courseController.retrieveLecturesInCourse(courseId: courseId, lectureIds: lectureIds)
                    }
                    
                    if self.shouldAddCourseToStack {
                        // add the newly focused course to the stack
                        
                        // MAKE SURE we aren't navigating back and the course was already focused and already in the stack
                        if courseController.focusedCourseStack.last != course {
                            print("appending to focus stack")
                            courseController.focusedCourseStack.append(course)
                        }
                    }
                }
                .onDisappear {
                    if self.shouldPopCourseFromStackOnDissapear {
                        print("course view is dissapearing, we're going to pop the course stack")
                        
                        // remove the top of the focused lecture stack, for backwards navigation
                        if let _ = courseController.focusedCourseStack.popLast() {
//                            print("")
                        }
                        
                        // also set the focused lecture to nil
                        courseController.focusedCourse = nil
                    } else {
                        print("course is dissapearing, but we're not popping it")
                        
                        // set the var back to true, it's default state - so if you return via nav stack, the propper behavior occurs
                        // set the var back to false if returning to the view
                        self.shouldPopCourseFromStackOnDissapear = true
                    }
                }
            } else {
                Text("no focused course")
            }
        }
        .onAppear {
            print("ON APPEAR - num things in the course stack: \(courseController.focusedCourseStack.count)")
            if courseController.focusedCourse == nil {
                print("course not focused yet, we'll try to focus the top of the stack")
                // if there's not a focused lecture, try to focus the top of the stack
                
                if let topCourse = courseController.focusedCourseStack.last {
                    courseController.focusCourse(topCourse)
                    // since the lecture was already in the stack, the resources should be cached
                    self.shouldAddCourseToStack = false
                }
            }
        }
        .onDisappear {
            print("ON DISAPPEAR - num things in the course stack: \(courseController.focusedCourseStack.count)")
        }
    }
}

#Preview {
    CourseView()
        .environmentObject(HomeController())
        .environmentObject(ExamController())
        .environmentObject(ExamAnswerController())
}
