//
//  CourseHistory.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct CourseHistory: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var myCourseController: MyCourseController
    
    var body: some View {
        // Coure History (preview)
        HStack {
            Text("Course History")
                .font(.system(size: 13, design: .serif))
                .bold()
            
            Spacer()
        }
        .padding(.top, 10)
        
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(myCourseController.recentWatchHistories, id: \.id) { watchHistory in
                    if let course = courseController.cachedCourses[watchHistory.courseId!] {
                        NavigationLink(destination: CourseView()) {
                            WatchedCourseCard(course: course, watchHistory: watchHistory)
                        }
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            courseController.focusCourse(course)
                        })
                    } else {
                        SkeletonLoader(width: 400 * 0.6, height: 150)
                    }
                }
                Button(action: {
                    
                }) {
                    Text("More")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.blue.opacity(0.6))
                        
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

#Preview {
    CourseHistory()
}
