//
//  CuratedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct CuratedCourses: View {
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Curated Courses")
                    .font(.system(size: 20, design: .serif))
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: CuratedCoursesFullList()) {
                    Text("View All")
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeController.communityFavorites, id: \.id) { course in
                        NavigationLink(destination: CourseView().onAppear {
                            print("tap registering")
                            homeController.focusCourse(course: course)
                        }) {
                            NewLectureView()
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    
//                    NavigationLink(destination: CourseView()) {
////                        FeaturedCourse(image: "mit", courseTitle: "Society of Mind", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
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
