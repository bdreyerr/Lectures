//
//  ComputerScience.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/12/25.
//

import SwiftUI

struct ComputerScience: View {
    var body: some View {
        
        CuratedCourses()
            .padding(.top, 10)
        
        CollectionsTrending()
            .padding(.top, 5)
        
        CommunityFavorites()
            .padding(.top, 10)

        LeadingUniversities()
            .padding(.top, 10)
    }
}

#Preview {
    ComputerScience()
}
