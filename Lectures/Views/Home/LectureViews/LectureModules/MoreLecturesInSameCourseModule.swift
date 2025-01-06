//
//  MoreLecturesInSameCourseModule.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/22/24.
//

import SwiftUI

struct MoreLecturesInSameCourseModule: View {
    
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        if let lecture = homeController.focusedLecture {
            if let lectures = homeController.lecturesInCourse[lecture.courseId!] {
                VStack {
                    HStack {
                        Text("More in")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        
                        Text(homeController.cachedCourses[lecture.courseId!]!.courseTitle!)
                            .font(.system(size: 14, design: .serif))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                    }
                    
                    ForEach(lectures, id: \.id) { lecture in
                        LectureInSameCourseModule(lecture: lecture)
                    }
                }
            }
        }
    }
}

struct LectureInSameCourseModule: View {
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var notesController: NotesController
    @EnvironmentObject var homeworkController: HomeworkController
    @EnvironmentObject var homeworkAnswersController: HomeworkAnswersController
    
    var lecture: Lecture
    
    var body: some View {
        // Other Lectures in the course
        HStack {
            // Image
            if let image = homeController.lectureThumbnails[lecture.id!] {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fill)
            } else {
                Image("google_logo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fill)
            }
            
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
        }
        .background((homeController.focusedLecture?.id! == lecture.id) ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(5)
        .onTapGesture {
            if homeController.focusedLecture?.id! != lecture.id {
                homeController.focusLecture(lecture)
                
                // we also gotta get the new lectures resources
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

#Preview {
    MoreLecturesInSameCourseModule()
        .environmentObject(HomeController())
}
