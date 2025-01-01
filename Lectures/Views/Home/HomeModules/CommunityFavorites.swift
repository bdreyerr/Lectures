//
//  CommunityFavorites.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct CommunityFavorites: View {
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Community Favorites")
                    .font(.system(size: 20, design: .serif))
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: CommunityFavoritesFullList()) {
                    Text("View All")
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(homeController.communityFavorites, id: \.id) { course in
                        NavigationLink(destination: CourseView()) {
                            NewLectureView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onTapGesture {
                            homeController.focusCourse(course: course)
                        }
                    }
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                    
//                    NavigationLink(destination: CourseView()) {
//                        NewLectureView()
//                    }
//                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    CommunityFavorites()
        .environmentObject(HomeController())
}
