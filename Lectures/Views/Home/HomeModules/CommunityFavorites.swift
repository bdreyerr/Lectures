//
//  CommunityFavorites.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct CommunityFavorites: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Community Favorites")
                .font(.system(size: 20, design: .serif))
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    NavigationLink(destination: CourseView()) {
                        FeaturedCourse(image: "mit2", courseTitle: "Emotional Intelligence", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CourseView()) {
                        FeaturedCourse(image: "stanford", courseTitle: "Machine Learning", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: CourseView()) {
                        FeaturedCourse(image: "mit2", courseTitle: "Calculus I", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    CommunityFavorites()
}
