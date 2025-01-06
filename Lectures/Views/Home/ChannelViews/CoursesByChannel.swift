//
//  CoursesByChannel.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct CoursesByChannel: View {
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        if let channel = homeController.focusedChannel {
            VStack {
                HStack {
                    Text("Courses by")
                        .font(.system(size: 14, design: .serif))
                        .bold()
                    
                    Text(channel.title ?? "")
                        .font(.system(size: 14, design: .serif))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                
                Group {
                    
                    ForEach(channel.courseIds!, id: \.self) { courseId in
                        NavigationLink(destination: CourseView()){
                            // CourseByChannelModule
                            CourseByChannelModule(courseId: courseId)
                        }
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            // get the course from the cache based on courseId
                            if let course = homeController.cachedCourses[courseId] {
                                homeController.focusCourse(course)
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        
    }
}

#Preview {
    CoursesByChannel()
}
