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
    
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var notesController: NotesController
    @EnvironmentObject var homeworkController: HomeworkController
    @EnvironmentObject var homeworkAnswersController: HomeworkAnswersController
    
    // Youtube player
    @EnvironmentObject var youTubePlayerController: YouTubePlayerController

    @State var duration: Double = 0.6
    
    @State var isLectureLiked: Bool = false
    
    @State private var dashPhase1: CGFloat = 0
    @State private var dashPhase2: CGFloat = 100
    @State private var hue1: Double = 0.0
    @State private var hue2: Double = 08
    
    var body: some View {
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
                    
//                    if let image = homeController.lectureThumbnails[lecture.id!] {
//                        Image(uiImage: image)
//                            .resizable()
//                            .border(Color.green)
//                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
//                            .aspectRatio(contentMode: .fit)
//                    } else {
//                        SkeletonLoader(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
//                    }
                    
                    // Add semi-transparent gradient overlay
//                    LinearGradient(
//                        gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
                    
                    
//                    HStack {
//                        Spacer()
//                        
//                        Circle()
//                            .fill(Color.white)
//                            .frame(width: 40, height: 40)
//                            .overlay(
//                                Image(systemName: "play.fill")
//                                    .foregroundColor(Color(hue: 0.001, saturation: 0.95, brightness: 0.973))
//                            )
//                            .padding()
//                    }
//                    
//                    // progress bar
//                    GeometryReader { geometry in
//                        Rectangle()
//                            .fill(Color.red)
//                            .frame(width: geometry.size.width * duration, height: 3) // 30% progress
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                    .frame(height: 3)
//                    .padding(.horizontal, 0)
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
                                        self.isLectureLiked.toggle()
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
                                ResourceChip(resource: note)
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
                                ResourceChip(resource: homework)
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
                                ResourceChip(resource: homeworkAnswer)
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
                } else {
                    print("lecture not focused yet")
                }
            }
        } else {
            Text("We couldn't load that lecture.")
        }
    }
}

#Preview {
    LectureView()
        .environmentObject(NotesController())
        .environmentObject(YouTubePlayerController())
}
