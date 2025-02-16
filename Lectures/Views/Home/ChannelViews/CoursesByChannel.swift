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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var channel: Channel
    
    var body: some View {
        if let courseIds = channel.courseIds {
            VStack {
                HStack {
                    Text("Courses by")
                        .font(.system(size: headerFontSize, design: .serif))
                        .bold()
                    
                    Text(channel.title ?? "")
                        .font(.system(size: headerFontSize, design: .serif))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                
                LazyVGrid(
                    columns: gridColumns,
                    spacing: gridSpacing
                ) {
                    ForEach(courseIds.prefix(courseController.channelCoursesPrefixPaginationNumber), id: \.self) { courseId in
                        if let course = courseController.cachedCourses[courseId] {
                            NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                                CourseByChannelModule(courseId: courseId)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                courseController.focusCourse(course)
                            })
                        }
                    }
                }
                
                if courseController.channelCoursesPrefixPaginationNumber < courseIds.count {
                    FetchButton(isMore: true) {
                        courseController.channelCoursesPrefixPaginationNumber += 10
                        
                        let coursesToRetrieve = courseIds.prefix(courseController.channelCoursesPrefixPaginationNumber)
                        
                        for courseId in coursesToRetrieve {
                            courseController.retrieveCourse(courseId: courseId)
                            courseController.getCourseThumbnail(courseId: courseId)
                        }
                    }
                    .padding(.top, topPadding)
                    .padding(.bottom, bottomPadding)
                }
                
                BottomBrandView()
            }
        }
    }
    
    // Computed properties for responsive sizing
    private var headerFontSize: CGFloat {
        horizontalSizeClass == .regular ? 18 : 14
    }
    
    private var gridColumns: [GridItem] {
        let columns = horizontalSizeClass == .regular ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: gridSpacing), count: columns)
    }
    
    private var gridSpacing: CGFloat {
        horizontalSizeClass == .regular ? 24 : 16
    }
    
    private var topPadding: CGFloat {
        horizontalSizeClass == .regular ? 16 : 10
    }
    
    private var bottomPadding: CGFloat {
        horizontalSizeClass == .regular ? 30 : 20
    }
}

//#Preview {
//    CoursesByChannel()
//}
