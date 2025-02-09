//
//  CoursesByChannel.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct CoursesByChannel: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        if let channel = courseController.focusedChannel, let courseIds = channel.courseIds {
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
                    ForEach(courseIds.prefix(courseController.channelCoursesPrefixPaginationNumber), id: \.self) { courseId in
                        NavigationLink(destination: CourseView()){
                            // CourseByChannelModule
                            CourseByChannelModule(courseId: courseId)
                        }
                        .simultaneousGesture(TapGesture().onEnded { _ in
                            // get the course from the cache based on courseId
                            if let course = courseController.cachedCourses[courseId] {
                                courseController.focusCourse(course)
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                
                if courseController.channelCoursesPrefixPaginationNumber < courseIds.count {
                    Button(action: {
                        // increment the prefix pagination var by 10, and fetch the new results
                        courseController.channelCoursesPrefixPaginationNumber += 10
                        
                        let coursesToRetrieve = courseIds.prefix(courseController.channelCoursesPrefixPaginationNumber)
                        
                        for courseId in coursesToRetrieve {
                            // Retrieve the course from firestore
                            courseController.retrieveCourse(courseId: courseId)
                            // Retrieve the thumbnail for the course from storage
                            courseController.getCourseThumbnail(courseId: courseId)
                        }
                    }) {
                        Text("Fetch More")
                            .font(.system(size: 10))
                            .opacity(0.8)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                
                BottomBrandView()
            }
        }
        
    }
}

#Preview {
    CoursesByChannel()
}
