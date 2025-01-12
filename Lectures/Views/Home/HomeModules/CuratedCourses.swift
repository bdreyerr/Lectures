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
                    .font(.system(size: 14, design: .serif))
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
                    ForEach(homeController.curatedCourses, id: \.id) { course in
                        
                        if homeController.isCuratedCoursesLoading {
                            SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                        } else {
                            NavigationLink(destination: CourseView()) {
                                CourseCardView(course: course)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                homeController.focusCourse(course)
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
