//
//  Trending.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/12/25.
//

import SwiftUI

struct Trending: View {
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        // the loading view
        if homeController.isUniversityLoading || homeController.isCuratedCoursesLoading || homeController.isCommunityFavoritesLoading {
            HomeLoadingView()
        } else {
//                        Categories()
//                            .padding(.top, 10)
            CollectionsTrending()
                .padding(.top, 5)
            
            
            CuratedCourses()
                .padding(.top, 10)
            
            // Otherwise the content is all loaded and ready to go
            LeadingUniversities()
                .padding(.top, 10)
            
            CommunityFavorites()
                .padding(.top, 10)
        }
    }
}

#Preview {
    Trending()
}
