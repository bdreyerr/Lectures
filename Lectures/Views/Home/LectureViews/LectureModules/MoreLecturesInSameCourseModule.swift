//
//  MoreLecturesInSameCourseModule.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/22/24.
//

import SwiftUI
import YouTubePlayerKit

struct MoreLecturesInSameCourseModule: View {
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
//    @Binding var playerSource: YouTubePlayer.Source?
    @ObservedObject var player: YouTubePlayer
    
    var body: some View {
        if let lecture = courseController.focusedLecture {
            if let lectures = courseController.lecturesInCourse[lecture.courseId!] {
                VStack {
                    HStack {
                        Text("More in")
                            .font(.system(size: 14))
//                            .font(.system(size: 14, design: .serif))
                            .bold()
                        
                        Text(courseController.cachedCourses[lecture.courseId!]!.courseTitle!)
                            .font(.system(size: 14, design: .serif))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                    }
                    
                    ForEach(lectures, id: \.id) { lecture in
                        LectureInSameCourseModule(lecture: lecture, player: player)
                    }
                }
            } else {
                HStack {
                    SkeletonLoader(width: 300, height: 40)
                    Spacer()
                }
            }
        }
    }
}

struct LectureInSameCourseModule: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var notesController: NotesController
    @EnvironmentObject var homeworkController: HomeworkController
    @EnvironmentObject var homeworkAnswersController: HomeworkAnswersController
    
    var lecture: Lecture
    
    @ObservedObject var player: YouTubePlayer
    
    var body: some View {
        // Other Lectures in the course
        HStack {
            // Image
            if let image = courseController.lectureThumbnails[lecture.id!] {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fill)
                
                // Lecture Name
                Rectangle()
                    .foregroundColor(Color.clear)
                    .frame(height: 40)
                    .overlay {
                        HStack {
                            Text(lecture.lectureTitle!)
                                .font(.system(size: 14, design: .serif))
                            
                            Spacer()
                            
                            // Lecture Number
                            Text("\(toRoman(lecture.lectureNumberInCourse!))")
                                .font(.system(size: 14, design: .serif))
                                .padding(.trailing, 20)
                        }
                    }
            } else {
                HStack {
                    SkeletonLoader(width: 300, height: 40)
                    Spacer()
                }
            }
            
            
        }
        .background((courseController.focusedLecture?.id! == lecture.id) ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(5)
        .onTapGesture {
            if courseController.focusedLecture?.id! != lecture.id {
                courseController.focusLecture(lecture)
                
                // change source url on youtube player
                player.source = .url(lecture.youtubeVideoUrl ?? "")
                
                // we also gotta get the new lectures resources
                if let lecture = courseController.focusedLecture {
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
        }
    }
    
    func toRoman(_ num: Int) -> String {
        let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let numerals = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
        var result = ""
        var number = num
        
        for (index, value) in values.enumerated() {
            while number >= value {
                result += numerals[index]
                number -= value
            }
        }
        
        return result
    }
}

//#Preview {
//    MoreLecturesInSameCourseModule()
//        .environmentObject(HomeController())
//}
