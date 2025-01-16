//
//  LectureView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI
import YouTubePlayerKit

struct LectureView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var watchHistoryController: WatchHistoryController
    
    // resource controllers
    @EnvironmentObject var notesController: NotesController
    @EnvironmentObject var homeworkController: HomeworkController
    @EnvironmentObject var homeworkAnswersController: HomeworkAnswersController
    
    // Youtube player
    @EnvironmentObject var youTubePlayerController: YouTubePlayerController
    
    @State var isLectureLiked: Bool = false
    
    // tracking if we're leaving lecture view in forward or backward navigation
    @State var shouldPopLectureFromStackOnDissapear: Bool = true
    
    @State private var isUpgradeAccountSheetShowing: Bool = false
    
    var body: some View {
        Group {
            if let lecture = homeController.focusedLecture {
                VStack {
                    // YouTubePlayer (starts video on page load)
                    ZStack(alignment: .bottomLeading) {
                        
                        // make sure the youtube url is attatched to this lecture
                        if let _ = lecture.youtubeVideoUrl {
                            YouTubePlayerView(youTubePlayerController.player) { state in
                                // Overlay ViewBuilder closure to place an overlay View
                                // for the current `YouTubePlayer.State`
                                switch state {
                                case .idle:
                                    //                                ProgressView()
                                    SkeletonLoader(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                                case .ready:
                                    EmptyView()
                                case .error(let error):
                                    Text(verbatim: "YouTube player couldn't be loaded: \(error)")
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                        } else {
                            SkeletonLoader(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                    .shadow(radius: 2.5)
                    //                .border(Color.black)
                    
                    
                    Spacer()
                    
                    // Course Indicator & Lecture Picker
                    ScrollView() {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(lecture.lectureTitle ?? "Title Not Found")
                                    .font(.system(size: 18, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Save button
                                if !isLectureLiked {
                                    Image(systemName: "heart")
                                        .font(.system(size: 18, design: .serif))
                                        .onTapGesture {
                                            // if the user isn't a PRO member, they can't like courses
                                            if let user = userController.user {
                                                if user.accountType == 1 {
                                                    withAnimation(.spring()) {
                                                        self.isLectureLiked.toggle()
                                                    }
                                                    // TODO: add logic to like a course
                                                    return
                                                }
                                            }
                                            
                                            // show the upgrade account sheet
                                            self.isUpgradeAccountSheetShowing = true
                                            
                                        }
                                } else {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 18, design: .serif))
                                        .foregroundStyle(Color.red)
                                        .onTapGesture {
                                            self.isLectureLiked.toggle()
                                        }
                                }
                            }
                            
                            // Professor if avaialble
                            Text(lecture.professorName ?? "")
                                .font(.system(size: 14, design: .serif))
                                .opacity(0.8)
                            
                            HStack {
                                Text("\(lecture.viewsOnYouTube ?? "0") Views")
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.8)
                                
                                Text(lecture.datePostedonYoutube ?? "")
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.8)
                            }
                            
                            // Course Publisher
                            HStack {
                                // TODO: Channel thumbnail
                                // Profile Picture
                                // channel image - nav link to channel view
                                NavigationLink(destination: ChannelView()) {
                                    if let channelImage = homeController.channelThumbnails[lecture.channelId!] {
                                        Image(uiImage: channelImage)
                                            .resizable()
                                        //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .frame(width: 40, height: 40)
                                    } else {
                                        Image("stanford")
                                            .resizable()
                                        //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    // we're leaving to channel view, so set var to not pop lecture from stack
                                    self.shouldPopLectureFromStackOnDissapear = false
                                    
                                    // focus a channel
                                    if let channel = homeController.cachedChannels[lecture.channelId!] {
                                        homeController.focusChannel(channel)
                                        
                                        
                                    }
                                })
                                .buttonStyle(PlainButtonStyle())
                                
                                
                                VStack {
                                    HStack {
                                        // channel image - nav link to channel view
                                        NavigationLink(destination: ChannelView()) {
                                            Text(lecture.channelName ?? "Channel Not Found")
                                                .font(.system(size: 12, design: .serif))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .simultaneousGesture(TapGesture().onEnded {
                                            // we're leaving to channel view, so set var to not pop lecture from stack
                                            self.shouldPopLectureFromStackOnDissapear = false
                                            
                                            // focus a channel
                                            if let channel = homeController.cachedChannels[lecture.channelId!] {
                                                homeController.focusChannel(channel)
                                            }
                                        })
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        Spacer()
                                        
                                        // TODO: add back channel stats
                                        if let course = homeController.cachedCourses[lecture.courseId!] {
                                            if let channel = homeController.cachedChannels[course.channelId!] {
                                                // TODO: Channel stats
                                                Text("\(channel.numCourses!) Courses | \(channel.numLectures!) Lectures")
                                                    .font(.system(size: 12, design: .serif))
                                                    .opacity(0.7)
                                            }
                                        }
                                    }
                                }
                            }
                            .cornerRadius(5)
                            
                            
                            // Lecture Description
                            ExpandableText(text: lecture.lectureDescription!, maxLength: 150)
                            
                            // Notes
                            HStack {
                                Text("Notes")
                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 14, design: .serif))
                                Spacer()
                            }
                            .padding(.top, 2)
                            
                            if let noteId = lecture.notesResourceId {
                                if let note = notesController.cachedNotes[noteId] {
                                    ResourceChip(resource: note, shouldPopFromStack: $shouldPopLectureFromStackOnDissapear)
                                } else {
                                    HStack {
                                        SkeletonLoader(width: 300, height: 40)
                                        Spacer()
                                    }
                                }
                            }
                            
                            
                            // Homework Assignment
                            HStack {
                                Text("Homework")
                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 14, design: .serif))
                                Spacer()
                            }
                            .padding(.top, 2)
                            
                            if let homeworkId = lecture.homeworkResourceId {
                                if let homework = homeworkController.cachedHomeworks[homeworkId] {
                                    ResourceChip(resource: homework, shouldPopFromStack: $shouldPopLectureFromStackOnDissapear)
                                } else {
                                    HStack {
                                        SkeletonLoader(width: 300, height: 40)
                                        Spacer()
                                    }
                                }
                            }
                            
                            // Homework Assignment
                            HStack {
                                Text("Homework Answers")
                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.blue)
                                    .font(.system(size: 14, design: .serif))
                                Spacer()
                            }
                            .padding(.top, 2)
                            
                            if let homeworkAnswerId = lecture.homeworkAnswersResourceId {
                                if let homeworkAnswer = homeworkAnswersController.cachedHomeworkAnswers[homeworkAnswerId] {
                                    ResourceChip(resource: homeworkAnswer, shouldPopFromStack: $shouldPopLectureFromStackOnDissapear)
                                } else {
                                    HStack {
                                        SkeletonLoader(width: 300, height: 40)
                                        Spacer()
                                    }
                                }
                            }
                            
                            
                            // Next Lessons
                            MoreLecturesInSameCourseModule()
                                .padding(.top, 10)
                        }
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                        
                        Divider()
                        
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
                }
                .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                    UpgradeAccountPaywallWithoutFreeTrial()
                }
                .onAppear {
                    // get the resource info
                    if let lecture = homeController.focusedLecture {
                        // notes
                        if let noteId = lecture.notesResourceId {
                            notesController.retrieveNote(noteId: noteId)
                        } else {
                            print("lecture didn't have an notes Id")
                        }
                        
                        // homework
                        if let homeworkId = lecture.homeworkResourceId {
                            homeworkController.retrieveHomework(homeworkId: homeworkId)
                        } else {
                            print("lecture didn't have an homework Id")
                        }
                        
                        // homework answers
                        if let homeworkAnswersId = lecture.homeworkAnswersResourceId {
                            homeworkAnswersController.retrieveHomeworkAnswer(homeworkAnswerId: homeworkAnswersId)
                        } else {
                            print("course didn't have an exam Id")
                        }
                        
                        // add the newly focused lecture to the stack
                        homeController.focusedLectureStack.append(lecture)
                        
                        // save a new watch history state
                        if let user = userController.user {
                            // only if the user is PRO member
                            if user.accountType == 1 {
                                // we should make sure we have the course somewhere, if we don't have the course what do we do?? Theres a case where lecture view can appear without first focusing a course
                                if let course = homeController.cachedCourses[lecture.courseId!] {
                                    // TODO: add a rate limit
                                    watchHistoryController.updateWatchHistory(userId: user.id!, course: course, lecture: lecture)
                                }
                            }
                        }
                    }
                }
                .onDisappear {
                    if self.shouldPopLectureFromStackOnDissapear {
                        print("lecture view is dissapearing, we're going to pop the lecture stack")
                        
                        // remove the top of the focused lecture stack, for backwards navigation
                        if let poppedLecture = homeController.focusedLectureStack.popLast() {
//                            print("")
                        }
                        
                        // also set the focused lecture to nil
                        homeController.focusedLecture = nil
                    } else {
                        print("lecture is dissapearing, but we're not popping it")
                    }
                }
            } else {
                Text("We couldn't load that lecture.")
            }
        }
        .onAppear {
            print("on appear on the group for lecture")
            if homeController.focusedLecture == nil {
                print("lecture not focused yet, we'll try to focus the top of the stack")
                // if there's not a focused lecture, try to focus the top of the stack
                
                if let topLecture = homeController.focusedLectureStack.last {
                    homeController.focusLecture(topLecture)
                    // since the lecture was already in the stack, the resources should be cached
                    
                    // change the YT player source
                    youTubePlayerController.changeSource(url: topLecture.youtubeVideoUrl ?? "")
                }
            }
        }
    }
}

#Preview {
    LectureView()
        .environmentObject(NotesController())
        .environmentObject(YouTubePlayerController())
        .environmentObject(WatchHistoryController())
}
