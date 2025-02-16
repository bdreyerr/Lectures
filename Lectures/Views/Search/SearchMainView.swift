//
//  SearchMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct SearchMainView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @StateObject var searchController = SearchController()
    
    @State var isUpgradeAccountPopupShowing: Bool = false
    @State var isSignUpSheetShowing: Bool = false
    
    @State var isUserPro: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TopBrandView()
                    
                    ScrollView(showsIndicators: false) {
                        if let user = userController.user, let accountType = user.accountType {
                            SearchBarWithFilters(accountType: accountType)
                        } else {
                            SearchBarWithFilters()
                        }
                        
                        
                        if searchController.displaySearchGraphic {
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray.opacity(0.3))
                                    .padding(.top, 40)
                                
                                HStack(spacing: 4) {
                                    Text("Search for any")
                                    Image(systemName: "mail.stack")
                                    Text("course,")
                                    Image(systemName: "newspaper")
                                    Text("lecture or")
                                    Image(systemName: "graduationcap")
                                    Text("university")
                                }
                                .font(.system(size: 12, design: .serif))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // loading
                        if searchController.isChannelsLoading || searchController.isCoursesLoading || searchController.isLecturesLoading {
                            SearchLoadingView()
                        } else {
                            
                            
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
                                    Image(systemName: "graduationcap")
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
                                                    NavigationLink(destination: ChannelView(channel: channel)) {
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
                                
                                
                                
                                HStack {
                                    if let user = userController.user, let accountType = user.accountType {
                                        if accountType == 1 {
                                            NavigationLink(destination: FullChannelSearchResults()) {
                                                Text("View all")
                                                    .font(.system(size: 10))
                                                    .opacity(0.8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        } else {
                                            Button(action: {
                                                isUpgradeAccountPopupShowing = true
                                            }) {
                                                Text("View all")
                                                    .font(.system(size: 10))
                                                    .opacity(0.8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.top, 1)
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
                                            VStack {
                                                ForEach(group, id: \.id) { course in
                                                    CourseSearchResult(course: course, displayOnFullResultsPage: false)
                                                }
//                                                Spacer() // if there's only  1 course, push it to the top
                                            }
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }
                                HStack {
                                    if let user = userController.user, let accountType = user.accountType {
                                        if accountType == 1 {
                                            NavigationLink(destination: FullCourseSearchResults()) {
                                                Text("View all")
                                                    .font(.system(size: 10))
                                                    .opacity(0.8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        } else {
                                            Button(action: {
                                                isUpgradeAccountPopupShowing = true
                                            }) {
                                                Text("View all")
                                                    .font(.system(size: 10))
                                                    .opacity(0.8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.top, 1)
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
                                //                            .padding(.top, 10)
                                
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(alignment: .top, spacing: 16) {
                                        let groupedLectures = stride(from: 0, to: searchController.searchResultLectures.count, by: 2).map { index in
                                            Array(searchController.searchResultLectures[index..<min(index + 2, searchController.searchResultLectures.count)])
                                        }
                                        
                                        ForEach(groupedLectures.indices, id: \.self) { groupIndex in
                                            let group = groupedLectures[groupIndex]
                                            VStack {
                                                ForEach(group, id: \.id) { lecture in
                                                    
                                                    LectureSearchResult(lecture: lecture, displayOnFullResultsPage: false)
                                                    
                                                    
                                                }
//                                                Spacer() // if there's only  1 lecture, push it to the top
                                            }
                                            .padding(.trailing, 10)
                                        }
                                    }
                                }
                                
                                
                                HStack {
                                    if let user = userController.user, let accountType = user.accountType {
                                        if accountType == 1 {
                                            NavigationLink(destination: FullLecturSearchResults()) {
                                                Text("View all")
                                                    .font(.system(size: 10))
                                                    .opacity(0.8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        } else {
                                            Button(action: {
                                                isUpgradeAccountPopupShowing = true
                                            }) {
                                                Text("View all")
                                                    .font(.system(size: 10))
                                                    .opacity(0.8)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.top, 1)
                            }
                        }
                    }
                    
                    
                    
                }
                .padding(.horizontal, 20)
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isUpgradeAccountPopupShowing) {
                UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountPopupShowing)
            }
        }
        // Needed for iPad compliance
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(searchController)
        .onAppear {
            // set filters depending on user status
            if let user = userController.user, let accountType = user.accountType {
                if accountType == 1 {
                    searchController.isCourseFilterSelected = true
                    searchController.isLectureFilterSelected = true
                    searchController.isChannelFilterSelected = true
                } else {
                    searchController.isCourseFilterSelected = true
                    searchController.isLectureFilterSelected = false
                    searchController.isChannelFilterSelected = false
                }
            }
        }
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
