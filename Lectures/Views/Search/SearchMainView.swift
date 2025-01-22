//
//  SearchMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct SearchMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var courseController: CourseController
    
    @StateObject var searchController = SearchController()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TopBrandView()
                    
                    ScrollView(showsIndicators: false) {
                        SearchBarWithFilters()
                        
                        
                        // loading
                        if searchController.isChannelsLoading && searchController.isCoursesLoading && searchController.isLecturesLoading {
                            // small loader for channel
                            
                            HStack {
                                SkeletonLoader(width: 300, height: 20)
                                Spacer()
                            }
                            HStack {
                                SkeletonLoader(width: 50, height: 50)
                                SkeletonLoader(width: 50, height: 50)
                                SkeletonLoader(width: 50, height: 50)
                                Spacer()
                            }
                            
                            // bigger loader for course
                            HStack {
                                SkeletonLoader(width: 300, height: 20)
                                Spacer()
                            }
                            HStack {
                                SkeletonLoader(width: 120, height: 67.5)
                                SkeletonLoader(width: 120, height: 67.5)
                                Spacer()
                            }
                            
                            // bigger loader for lecture
                            HStack {
                                SkeletonLoader(width: 300, height: 20)
                                Spacer()
                            }
                            HStack {
                                SkeletonLoader(width: 120, height: 67.5)
                                SkeletonLoader(width: 120, height: 67.5)
                                Spacer()
                            }
                        }
                        
                        
                        if searchController.searchResultChannels.isEmpty && searchController.searchResultCourses.isEmpty && searchController.searchResultLectures.isEmpty {
                            if searchController.wasSearchPerformed {
                                HStack {
                                    Text("0 Results Found")
                                        .font(.system(size: 12))
                                        .bold()
                                    Spacer()
                                }
                                .padding(.top, 10)
                            }
                        } else {
                            if searchController.wasSearchPerformed {
                                if searchController.wasSearchPerformed {
                                    if !searchController.isCoursesLoading && !searchController.isLecturesLoading && !searchController.isChannelsLoading {
                                        HStack {
                                            Text("Search Results (\(searchController.searchResultChannels.count + searchController.searchResultCourses.count + searchController.searchResultLectures.count))")
                                                .font(.system(size: 12))
                                                .bold()
                                            Spacer()
                                        }
                                        .padding(.top, 10)
                                    }
                                }
                            }
                        }
                        
                        
                        
                        // channels
                        if !searchController.searchResultChannels.isEmpty {
                            HStack {
                                Image(systemName: "person")
                                    .font(.system(size: 10))
                                    .opacity(0.8)
                                
                                Text("Channels")
                                    .font(.system(size: 10))
                                    .opacity(0.8)
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 16) {
                                    let groupedChannels = stride(from: 0, to: searchController.searchResultChannels.count, by: 2).map { index in
                                        Array(searchController.searchResultChannels[index..<min(index + 2, searchController.searchResultChannels.count)])
                                    }
                                    
                                    ForEach(groupedChannels.indices, id: \.self) { groupIndex in
                                        let group = groupedChannels[groupIndex]
                                        VStack(spacing: 16) {
                                            ForEach(group, id: \.id) { channel in
                                                NavigationLink(destination: ChannelView()) {
                                                    ChannelCard(channel: channel)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .simultaneousGesture(TapGesture().onEnded {
                                                    courseController.focusChannel(channel)
                                                })
                                            }
                                            
                                        }
                                        .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                        
                        if !searchController.searchResultCourses.isEmpty {
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
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 16) {
                                    let groupedCourses = stride(from: 0, to: searchController.searchResultCourses.count, by: 2).map { index in
                                        Array(searchController.searchResultCourses[index..<min(index + 2, searchController.searchResultCourses.count)])
                                    }
                                    
                                    ForEach(groupedCourses.indices, id: \.self) { groupIndex in
                                        let group = groupedCourses[groupIndex]
                                        VStack(spacing: 16) {
                                            ForEach(group, id: \.id) { course in
                                                CourseSearchResult(course: course)
                                            }
                                            Spacer() // if there's only  1 course, push it to the top
                                        }
                                        .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                        
                        
                        if !searchController.searchResultLectures.isEmpty {
                            HStack {
                                Image(systemName: "newspaper")
                                    .font(.system(size: 10))
                                    .opacity(0.8)
                                
                                Text("Lectures")
                                    .font(.system(size: 10))
                                    .opacity(0.8)
                                Spacer()
                            }
//                            .padding(.top, 10)
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 16) {
                                    let groupedLectures = stride(from: 0, to: searchController.searchResultLectures.count, by: 2).map { index in
                                        Array(searchController.searchResultLectures[index..<min(index + 2, searchController.searchResultLectures.count)])
                                    }
                                    
                                    ForEach(groupedLectures.indices, id: \.self) { groupIndex in
                                        let group = groupedLectures[groupIndex]
                                        VStack(spacing: 16) {
                                            ForEach(group, id: \.id) { lecture in
                                                NavigationLink(destination: LectureView()) {
                                                    LectureSearchResult(lecture: lecture)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .simultaneousGesture(TapGesture().onEnded {
                                                    courseController.focusLecture(lecture)
                                                })
                                            }
                                            Spacer() // if there's only  1 lecture, push it to the top
                                        }
                                        .padding(.trailing, 10)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 20)
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarHidden(true)
            .environmentObject(searchController)
        }
        // Needed for iPad compliance
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    SearchMainView()
}
