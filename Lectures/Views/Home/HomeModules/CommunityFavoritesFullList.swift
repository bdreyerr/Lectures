//
//  CommunityFavoritesFullList.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct CommunityFavoritesFullList: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false ) {
                // tech & comp sci
                CategoryCourseList(categoryName: "Popular Among Lectura Users")
                
                CategoryCourseList(categoryName: "Most Watched on Youtube")
                
                CategoryCourseList(categoryName: "Top Universities")
                
                CategoryCourseList(categoryName: "Trending Lecture Topics")
                
                CategoryCourseList(categoryName: "Famous Professors")
                
                
                Spacer()
                
                BottomBrandView()
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CommunityFavoritesFullList()
}
