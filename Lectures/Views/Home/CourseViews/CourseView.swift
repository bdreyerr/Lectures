//
//  CourseView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var examController: ExamController
    @EnvironmentObject var examAnswerController: ExamAnswerController

    @EnvironmentObject var subscriptionController: SubscriptionController
    
    // TODO: move these into user controller rather than local on this view
    @State var isCourseLiked: Bool = false
    @State private var isChannelFollowed = false
    
    @State private var shouldPopCourseFromStackOnDissapear: Bool = true
    @State private var shouldAddCourseToStack: Bool = true
    
    @State private var isUpgradeAccountSheetShowing: Bool = false
    @State private var isSignInSheetShowing: Bool = false
    
    var body: some View {
        Group {
            if let course = courseController.focusedCourse, let courseId = course.id, let channelId = course.channelId, let courseTitle = course.courseTitle,  let courseDescription = course.courseDescription, let numLecturesInCourse = course.numLecturesInCourse, let watchTimeInHrs = course.watchTimeInHrs, let aggregateViews = course.aggregateViews {
                VStack {
                    ScrollView(showsIndicators: false) {
//                        if let courseImage = courseController.courseThumbnails[courseId] {
//                            ZStack(alignment: .bottomLeading) {
//                                Image(uiImage: courseImage)
//                                    .resizable()
//                                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.4)
//                                
//                            }
//                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.4)
//                            .shadow(radius: 2.5)
//                        }
                        VStack(spacing: 5) {
                            // Course Cover Image
                           
                            
                            
                            HStack {
                                // Course title and University
                                VStack {
                                    Text(courseTitle)
                                        .font(.system(size: 18, design: .serif))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                

                                // Like Course Button
                                Button(action: {
                                    // if the user isn't a PRO member, they can't like courses
                                    if subscriptionController.isPro {
                                        if let rateLimit = rateLimiter.processWrite() {
                                            print(rateLimit)
                                            return
                                        }
                                        if let user = userController.user, let userId = user.id {
                                            userController.likeCourse(userId: userId, courseId: courseId)
                                            withAnimation(.spring()) {
                                                self.isCourseLiked.toggle()
                                            }
                                        }
                                        return
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
                                Text("\(numLecturesInCourse) Lectures")
                                    .font(.system(size: 12))
//                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                
                                Text("\(watchTimeInHrs)Hr Watch Time")
                                    .font(.system(size: 12))
//                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                                
                                Text("\(formatIntViewsToString(numViews: aggregateViews)) Views")
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
                                        SkeletonLoader(width: 50, height: 40)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom, 12)
                            
                            
                            
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
                                    if subscriptionController.isPro {
                                        if let rateLimit = rateLimiter.processWrite() {
                                            print(rateLimit)
                                            return
                                        }
                                        
                                        if let user = userController.user, let userId = user.id {
                                            userController.followChannel(userId: userId, channelId: channelId)
                                            withAnimation(.spring()) {
                                                isChannelFollowed.toggle()
                                            }
                                        }
                                        return
                                    }
                                    
                                    self.isUpgradeAccountSheetShowing = true
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
                            
                            
                            // TODO: Add back resources if we are adding them to the app
                            // Resources
//                            HStack {
//                                Text("Resources")
//                                    .font(.system(size: 14))
//                                Image(systemName: "sparkles")
//                                    .foregroundStyle(Color.blue)
//                                    .font(.system(size: 14, design: .serif))
//                                Spacer()
//                            }
//                            .padding(.top, 20)
//                            
//                            
//                            // Exam                            
//                            if let examId = course.examResourceId {
//                                if let exam = examController.cachedExams[examId] {
//                                    ResourceChip(resource: exam, shouldPopFromStack: $shouldPopCourseFromStackOnDissapear)
//                                        .padding(.bottom, 2)
//                                } else {
//                                    HStack {
//                                        SkeletonLoader(width: 300, height: 40)
//                                        Spacer()
//                                    }
//                                }
//                            }
//                            
//                            // Exam Answers
//                            if let examAnswerId = course.examAnswersResourceId {
//                                if let examAnswer = examAnswerController.cachedExamAnswers[examAnswerId] {
//                                    ResourceChip(resource: examAnswer, shouldPopFromStack: $shouldPopCourseFromStackOnDissapear)
//                                } else {
//                                    HStack {
//                                        SkeletonLoader(width: 300, height: 40)
//                                        Spacer()
//                                    }
//                                }
//                            }
                            
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
                                        ScrollView(showsIndicators: false) {
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
//                                                .padding(2)
                                            }
                                            
                                            
                                            if let lectureIds = course.lectureIds {
                                                if courseController.lecturesInCoursePrefixPaginationNumber < lectureIds.count {
                                                    Button(action: {
                                                        courseController.lecturesInCoursePrefixPaginationNumber += 8
                                                        
                                                        courseController.retrieveLecturesInCourse(courseId: courseId, lectureIds: lectureIds, isFetchingMore: true)
                                                        
                                                    }) {
                                                        Text("Fetch More")
                                                            .font(.system(size: 10))
                                                            .opacity(0.8)
                                                    }
                                                    .padding(.top, 5)
                                                    .padding(.bottom, 10)
                                                }
                                            }
                                            
                                        }
                                        .frame(maxHeight: 300)  // Added maxHeight
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 8)
//                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                                        )
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
                            RelatedCourses()
                            
                            BottomBrandView()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $isSignInSheetShowing) {
                    FirstOpenSignUpSheet(text: "Sign In", displaySheet: $isSignInSheetShowing)
                        .presentationDetents([.fraction(0.25), .medium]) // User can drag between these heights
                }
                .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                    UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
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
                    
                    // get the lectures in this course
                    if let lectureIds = course.lectureIds {
                        print("retrieving lectures in course gang")
                        courseController.retrieveLecturesInCourse(courseId: courseId, lectureIds: lectureIds, isFetchingMore: false)
                    } else {
                        print("lecture ids not ready on a new focused course?")
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
                ErrorLoadingView()
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
    CourseView()
        .environmentObject(HomeController())
        .environmentObject(ExamController())
        .environmentObject(ExamAnswerController())
}
