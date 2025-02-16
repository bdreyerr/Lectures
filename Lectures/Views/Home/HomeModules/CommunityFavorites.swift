//
//  CommunityFavorites.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct CommunityFavorites: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                
                Image(systemName: "party.popper")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Famous Lectures")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(homeController.communityFavorites, id: \.id) { course in
                        if homeController.isCommunityFavoritesLoading {
                            SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                        } else {
                            NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                                CourseCardView(course: course)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                courseController.focusCourse(course)
                            })
                        }
                    }
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
