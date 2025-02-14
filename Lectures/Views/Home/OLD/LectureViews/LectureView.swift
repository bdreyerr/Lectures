////
////  LectureView.swift
////  Lectures
////
////  Created by Ben Dreyer on 12/19/24.
////
//
//import SwiftUI
//import YouTubePlayerKit
//
//struct LectureView: View {
//    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.presentationMode) var presentationMode
//    
//    @EnvironmentObject var rateLimiter: RateLimiter
//    
//    @EnvironmentObject var courseController: CourseController
//    @EnvironmentObject var userController: UserController
//    @EnvironmentObject var homeController: HomeController
//    @EnvironmentObject var myCourseController: MyCourseController
//    
//    @EnvironmentObject var subscriptionController: SubscriptionController
//    
//    // resource controllers
//    @EnvironmentObject var notesController: NotesController
//    @EnvironmentObject var homeworkController: HomeworkController
//    @EnvironmentObject var homeworkAnswersController: HomeworkAnswersController
//    
//    // YT player - local to each lecture view
//    @StateObject public var player: YouTubePlayer = ""
//    
//    @State var isLectureLiked: Bool = false
//    
//    // tracking if we're leaving lecture view in forward or backward navigation
//    @State var shouldPopLectureFromStackOnDissapear: Bool = true
//    @State var shouldAddLectureToStack: Bool = true
//    
//    @State private var isUpgradeAccountSheetShowing: Bool = false
//    
//    var body: some View {
//        Group {
//            if let lecture = courseController.focusedLecture, let lectureId = lecture.id, let courseId = lecture.courseId, let professorName = lecture.professorName, let channelId = lecture.channelId, let viewsOnYouTube = lecture.viewsOnYouTube, let datePostedonYoutube = lecture.datePostedonYoutube, let lectureDescription = lecture.lectureDescription {
//                VStack {
//                    // YouTubePlayer (starts video on page load)
//                    ZStack(alignment: .bottomLeading) {
//                        
//                        // make sure the youtube url is attatched to this lecture
//                        YouTubePlayerView(self.player) { state in
//                                // Overlay ViewBuilder closure to place an overlay View
//                                // for the current `YouTubePlayer.State`
//                                switch state {
//                                case .idle:
//                                    ProgressView()
////                                    SkeletonLoader(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
//                                case .ready:
//                                    EmptyView()
//                                case .error(let error):
//                                    Text(verbatim: "YouTube player couldn't be loaded: \(error)")
//                                }
//                            }
//                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
//                            .onChange(of: player.source) {
//                                print("yt player source changed?")
//                            }
//                        
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
//                    .shadow(radius: 2.5)
//                    
//                    
//                    Spacer()
//                    
//                    // Course Indicator & Lecture Picker
//                    ScrollView() {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Text(lecture.lectureTitle ?? "Title Not Found")
//                                    .font(.system(size: 18, design: .serif))
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                
//                                // Like Lecture button
//                                Button(action: {
//                                    if subscriptionController.isPro {
//                                        if let user = userController.user, let userId = user.id {
//                                            if let rateLimit = rateLimiter.processWrite() {
//                                                print(rateLimit)
//                                                return
//                                            }
//                                            
//                                            userController.likeLecture(userId: userId, lectureId: lectureId)
//                                            withAnimation(.spring()) {
//                                                self.isLectureLiked.toggle()
//                                            }
//                                        }
//                                        return
//                                    }
//
//                                    self.isUpgradeAccountSheetShowing = true
//                                }) {
//                                    Image(systemName: isLectureLiked ? "heart.fill" : "heart")
//                                        .font(.system(size: 18, design: .serif))
//                                        .foregroundStyle(isLectureLiked ? Color.red : colorScheme == .light ? Color.black : Color.white)
//                                }
//                            }
//                            
//                            // Professor if avaialble
//                            Text(professorName)
//                                .font(.system(size: 14, design: .serif))
//                                .opacity(0.8)
//                            
//                            HStack {
//                                Text("\(formatIntViewsToString(numViews: viewsOnYouTube)) Views")
//                                    .font(.system(size: 12))
////                                    .font(.system(size: 12, design: .serif))
//                                    .opacity(0.8)
//                                
//                                Text(datePostedonYoutube)
//                                    .font(.system(size: 12))
////                                    .font(.system(size: 12, design: .serif))
//                                    .opacity(0.8)
//                            }
//                            
//                            // Course Publisher
//                            HStack {
//                                // TODO: Channel thumbnail
//                                // Profile Picture
//                                // channel image - nav link to channel view
////                                NavigationLink(destination: ChannelView()) {
////                                    if let channelImage = courseController.channelThumbnails[channelId] {
////                                        Image(uiImage: channelImage)
////                                            .resizable()
////                                        //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
////                                            .frame(width: 40, height: 40)
////                                    } else {
////                                        Image("stanford")
////                                            .resizable()
////                                        //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
////                                            .frame(width: 40, height: 40)
////                                    }
////                                }
////                                .simultaneousGesture(TapGesture().onEnded {
////                                    // we're leaving to channel view, so set var to not pop lecture from stack
////                                    self.shouldPopLectureFromStackOnDissapear = false
////                                    
////                                    // focus a channel
////                                    if let channel = courseController.cachedChannels[channelId] {
////                                        courseController.focusChannel(channel)
////                                        
////                                        
////                                    }
////                                })
////                                .buttonStyle(PlainButtonStyle())
//                                
//                                
//                                VStack {
//                                    HStack {
//                                        // channel image - nav link to channel view
////                                        NavigationLink(destination: ChannelView()) {
////                                            Text(lecture.channelName ?? "Channel Not Found")
////                                                .font(.system(size: 12, design: .serif))
////                                                .frame(maxWidth: .infinity, alignment: .leading)
////                                        }
////                                        .simultaneousGesture(TapGesture().onEnded {
////                                            // we're leaving to channel view, so set var to not pop lecture from stack
////                                            self.shouldPopLectureFromStackOnDissapear = false
////                                            
////                                            // focus a channel
////                                            if let channel = courseController.cachedChannels[channelId] {
////                                                courseController.focusChannel(channel)
////                                            }
////                                        })
////                                        .buttonStyle(PlainButtonStyle())
//                                        
//                                        Spacer()
//                                        
//                                        // TODO: add back channel stats
//                                        if let course = courseController.cachedCourses[courseId] {
//                                            if let channel = courseController.cachedChannels[channelId], let numCourses = channel.numCourses, let numLectures = channel.numLectures {
//                                                // TODO: Channel stats
//                                                Text("\(numCourses) Courses | \(numLectures) Lectures")
//                                                    .font(.system(size: 12))
////                                                    .font(.system(size: 12, design: .serif))
//                                                    .opacity(0.7)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            .cornerRadius(5)
//                            .padding(.top, 5)
//                            
//                            
//                            
//                            // Lecture Description
//                            ExpandableText(text: lectureDescription, maxLength: 150)
//                                .padding(.top, 10)
//                            
//                            
//                            HStack {
//                                Text("Notes")
//                                    .font(.system(size: 14))
////                                    .font(.system(size: 14, design: .serif))
//                                Image(systemName: "sparkles")
//                                    .foregroundStyle(Color.blue)
//                                    .font(.system(size: 14, design: .serif))
//                                Spacer()
//                            }
//                            .padding(.top, 20)
//                            
//                            // Notes
//                            if let noteId = lecture.notesResourceId {
//                                if let note = notesController.cachedNotes[noteId] {
//                                    ResourceChip(resource: note, shouldPopFromStack: $shouldPopLectureFromStackOnDissapear)
//                                        .padding(.bottom, 2)
//                                } else {
//                                    HStack {
//                                        SkeletonLoader(width: 300, height: 40)
//                                        Spacer()
//                                    }
//                                }
//                            }
//                            
//                            
////                            // Homework Assignment
////                            if let homeworkId = lecture.homeworkResourceId {
////                                if let homework = homeworkController.cachedHomeworks[homeworkId] {
////                                    ResourceChip(resource: homework, shouldPopFromStack: $shouldPopLectureFromStackOnDissapear)
////                                        .padding(.bottom, 2)
////                                } else {
////                                    HStack {
////                                        SkeletonLoader(width: 300, height: 40)
////                                        Spacer()
////                                    }
////                                }
////                            }
////                            
////                            // Homework Assignment
////                            if let homeworkAnswerId = lecture.homeworkAnswersResourceId {
////                                if let homeworkAnswer = homeworkAnswersController.cachedHomeworkAnswers[homeworkAnswerId] {
////                                    ResourceChip(resource: homeworkAnswer, shouldPopFromStack: $shouldPopLectureFromStackOnDissapear)
////                                        .padding(.bottom, 2)
////                                } else {
////                                    HStack {
////                                        SkeletonLoader(width: 300, height: 40)
////                                        Spacer()
////                                    }
////                                }
////                            }
//                            
//                            // Play on youtube button
//                            if let url = lecture.youtubeVideoUrl {
//                                WatchOnYouTubeButton(videoUrl: url)
//                            }
//                            
//                            
//                            
//                            // Next Lessons
//                            MoreLecturesInSameCourseModule(player: player)
//                                .padding(.top, 20)
//                        }
//                        .padding(.top, 5)
//                        .padding(.horizontal, 20)
//                        
//                        Divider()
//                        
//                        BottomBrandView()
//                    }
//                }
//                .sheet(isPresented: $isUpgradeAccountSheetShowing) {
//                    UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
//                }
//                .onAppear {
//                    // we need to fetch a separate list of lectures in this same course. this is becaus the user may be watching lecture 35, and that may not match up with what we retrieved for dispalying on course view, which is stored in lecturesInCourse. instead, we write and read from lecturesInSameCourse
//                    if let course = courseController.cachedCourses[courseId], let courseId = course.id, let lectureIds = course.lectureIds {
//                        
//                        if let lectureNum = lecture.lectureNumberInCourse {
//                            courseController.retrievLecturesInSameCourse(courseId: courseId, lectureIds: lectureIds, currentLectureNum: lectureNum)
//                        }
//                    }
//                    
//                    
//                    // if the user already likes this lecture, change the heart view to red
//                    if let user = userController.user, let likedLectureIds = user.likedLectureIds {
//                        if likedLectureIds.contains(lectureId) {
//                            self.isLectureLiked = true
//                        }
//                    }
//                    
//                    // get the resource info
//                    
//                    // notes
//                    if let noteId = lecture.notesResourceId {
//                        notesController.retrieveNote(noteId: noteId)
//                    } else {
//                        print("lecture didn't have an notes Id")
//                    }
//                    
//                    // homework
////                    if let homeworkId = lecture.homeworkResourceId {
////                        homeworkController.retrieveHomework(homeworkId: homeworkId)
////                    } else {
////                        print("lecture didn't have an homework Id")
////                    }
////                    
////                    // homework answers
////                    if let homeworkAnswersId = lecture.homeworkAnswersResourceId {
////                        homeworkAnswersController.retrieveHomeworkAnswer(homeworkAnswerId: homeworkAnswersId)
////                    } else {
////                        print("course didn't have an exam Id")
////                    }
//                    
//                    if self.shouldAddLectureToStack {
//                        
//                        if courseController.focusedLectureStack.last != lecture {    
//                            // add the newly focused lecture to the stack
//                            courseController.focusedLectureStack.append(lecture)
//                            
//                            // save a new watch history state
//                            if let user = userController.user, let userId = user.id {
//                                // only if the user is PRO member
//                                if user.accountType == 1 {
//                                    // we should make sure we have the course somewhere, if we don't have the course what do we do?? Theres a case where lecture view can appear without first focusing a course
//                                    if let course = courseController.cachedCourses[courseId] {
//                                        // TODO: add a rate limit
//                                        myCourseController.updateWatchHistory(userId: userId, course: course, lecture: lecture)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                .onDisappear {
//                    if self.shouldPopLectureFromStackOnDissapear {
//                        print("lecture view is dissapearing, we're going to pop the lecture stack")
//                        
//                        // remove the top of the focused lecture stack, for backwards navigation
//                        if let poppedLecture = courseController.focusedLectureStack.popLast() {
//                            //                            print("")
//                        }
//                        
//                        // also set the focused lecture to nil
//                        courseController.focusedLecture = nil
//                    } else {
//                        print("lecture is dissapearing, but we're not popping it")
//                        
//                        self.shouldPopLectureFromStackOnDissapear = true
//                    }
//                }
//            } else {
//                ErrorLoadingView()
//            }
//        }
//        .onAppear {
//            // TODO: how can we speed this up?
//            if let lecture = courseController.focusedLecture, let youtubeVideoUrl = lecture.youtubeVideoUrl {
//                // load the youtube video
//                self.player.source = .url(youtubeVideoUrl)
//            }
//            
//            
//            if courseController.focusedLecture == nil {
//                print("lecture not focused yet, we'll try to focus the top of the stack")
//                // if there's not a focused lecture, try to focus the top of the stack
//                
//                if let topLecture = courseController.focusedLectureStack.last {
//                    courseController.focusLecture(topLecture)
//                    // since the lecture was already in the stack, the resources should be cached
//                    
//                    // change the YT player source
//                    self.player.source = .url(topLecture.youtubeVideoUrl ?? "")
//                    
//                    
//                    self.shouldAddLectureToStack = false
//                }
//            }
//        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image(systemName: "chevron.left")
//                    .bold()
//                Text("Back")
//            }
//        })
//    }
//    
//    func formatIntViewsToString(numViews: Int) -> String {
//        switch numViews {
//            case 0..<1_000:
//                return String(numViews)
//            case 1_000..<1_000_000:
//                let thousands = Double(numViews) / 1_000.0
//                return String(format: "%.0fk", thousands)
//            case 1_000_000...:
//                let millions = Double(numViews) / 1_000_000.0
//                return String(format: "%.0fM", millions)
//            default:
//                return "0"
//            }
//    }
//}
//
//#Preview {
//    LectureView()
//        .environmentObject(NotesController())
//        .environmentObject(MyCourseController())
//}
