////
////  LecturesInCourse.swift
////  Lectures
////
////  Created by Ben Dreyer on 12/28/24.
////
//
//import SwiftUI
//
//struct LecturesInCourse: View {
//    @EnvironmentObject var homeController: HomeController
//    
//    // Youtube player
//    @EnvironmentObject var youTubePlayerController: YouTubePlayerController
//    
//    var course: Course
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Lectures In")
//                    .font(.system(size: 14, design: .serif))
//                    .bold()
//                
//                Text(course.courseTitle ?? "Title")
//                    .font(.system(size: 14, design: .serif))
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//                
//                Spacer()
//            }
//            
//            Group {
//                if let lectures = homeController.lecturesInCourse[course.id!] {
//                    ForEach(lectures, id: \.id) { lecture in
//                        NavigationLink(destination: LectureView()) {
//                            LectureInCourseModule(lecture: lecture)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .simultaneousGesture(TapGesture().onEnded {
//                            // focus the lecture
//                            homeController.focusLecture(lecture)
//                            // change the YT player source url
//                            youTubePlayerController.changeSource(url: lecture.youtubeVideoUrl ?? "")
//                        })
//                    }
//                } else {
//                    HStack {
//                        SkeletonLoader(width: 300, height: 40)
//                        Spacer()
//                    }
//                }
//            }
//        }
//    }
//}
//
//
////
////#Preview {
////    LecturesInCourse(course: Course())
////        .environmentObject(HomeController())
////        .environmentObject(YouTubePlayerController())
////}
