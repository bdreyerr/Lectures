//
//  FullCourseSearchResults.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct FullCourseSearchResults: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var searchController: SearchController
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Image(systemName: "mail.stack")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Text("Courses")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    Spacer()
                }
                .padding(.top, 10)
                
                ForEach(searchController.searchResultCourses, id: \.id) { course in
                    HStack {
                        CourseSearchResult(course: course, displayOnFullResultsPage: true)
                        Spacer()
                    }
                }
                
                if !searchController.noCoursesLeftToLoad {
                    
                    FetchButton(isMore: true) {
                        searchController.getMoreCourses(courseController: courseController)
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 80)
                    
                    
                }
                
                Spacer()
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    FullCourseSearchResults()
}
