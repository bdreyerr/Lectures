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
                
                // Logo
                if (colorScheme == .light) {
                    Image("LogoTransparentWhiteBackground")
                        .resizable()
                        .frame(width: 80, height: 80)
                } else if (colorScheme == .dark) {
                    Image("LogoBlackBackground")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                Text("Lectura")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .opacity(0.8)
                Text("version 1.1")
                    .font(.system(size: 11, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .opacity(0.8)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CommunityFavoritesFullList()
}
