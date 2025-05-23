//
//  FullLecturSearchResults.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct FullLecturSearchResults: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var searchController: SearchController
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Image(systemName: "newspaper")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Text("Lectures")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    Spacer()
                }
                .padding(.top, 10)
                
                ForEach(searchController.searchResultLectures, id: \.id) { lecture in
                    HStack {
                        LectureSearchResult(lecture: lecture, displayOnFullResultsPage: true)
                        Spacer()
                    }
                }
                
                if !searchController.noLecturesLeftToLoad {
                    
                    FetchButton(isMore: true) {
                        searchController.getMoreLectures(courseController: courseController)
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
    FullLecturSearchResults()
}
