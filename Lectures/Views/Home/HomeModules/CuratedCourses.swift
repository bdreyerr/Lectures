//
//  CuratedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct CuratedCourses: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "mail.stack")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Courses For You")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeController.curatedCourses, id: \.id) { course in
                        
                        if homeController.isCuratedCoursesLoading {
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

#Preview {
    CuratedCourses()
        .environmentObject(HomeController())
}
