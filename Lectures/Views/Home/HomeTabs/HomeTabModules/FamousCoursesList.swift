//
//  FamousCoursesList.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/15/25.
//

import SwiftUI

struct FamousCoursesList: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var tabName: String
    
    var body: some View {
        if let courses = homeController.famousCoursesPerTab[tabName] {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "mail.stack")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Text("Popular Courses")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(courses, id: \.id) { course in
                            if homeController.isFamousCoursesLoading {
                                SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                            } else {
                                NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                                    CourseCardView(course: course)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .simultaneousGesture(TapGesture().onEnded {
                                    courseController.focusCourse(course)
                                })
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: 220)
        }
    }
}

//#Preview {
//    FamousCoursesList()
//}
