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
                                                if searchController.isChannelsLoading {
                                                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 40)
                                                } else {
                                                    NavigationLink(destination: ChannelView()) {
                                                        ChannelCard(channel: channel)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                    .simultaneousGesture(TapGesture().onEnded {
                                                        courseController.focusChannel(channel)
                                                    })
                                                }
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
                            .padding(.bottom, 2)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 16) {
                                    let groupedCourses = stride(from: 0, to: searchController.searchResultCourses.count, by: 2).map { index in
                                        Array(searchController.searchResultCourses[index..<min(index + 2, searchController.searchResultCourses.count)])
                                    }
                                    
                                    ForEach(groupedCourses.indices, id: \.self) { groupIndex in
                                        let group = groupedCourses[groupIndex]
                                        VStack(spacing: 16) {
                                            ForEach(group, id: \.id) { course in
                                                if searchController.isCoursesLoading {
                                                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                                                } else {
                                                    CourseSearchResult(course: course)
                                                }
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
                            .padding(.top, 10)
                            .padding(.bottom, 2)
                            
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 16) {
                                    let groupedLectures = stride(from: 0, to: searchController.searchResultLectures.count, by: 2).map { index in
                                        Array(searchController.searchResultLectures[index..<min(index + 2, searchController.searchResultLectures.count)])
                                    }
                                    
                                    ForEach(groupedLectures.indices, id: \.self) { groupIndex in
                                        let group = groupedLectures[groupIndex]
                                        VStack(spacing: 16) {
                                            ForEach(group, id: \.id) { lecture in
                                                if searchController.isLecturesLoading {
                                                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 40)
                                                } else {
                                                    NavigationLink(destination: LectureView()) {
                                                        LectureSearchResult(lecture: lecture)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                    .simultaneousGesture(TapGesture().onEnded {
                                                        courseController.focusLecture(lecture)
                                                    })
                                                }
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
    }
}

// Add this helper view for filter chips
struct FilterChip: View {
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, design: .serif))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.black : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 0.5)
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

#Preview {
    SearchMainView()
}
