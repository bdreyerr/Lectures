//
//  AllCoursesList.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct CuratedCoursesFullList: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(showsIndicators: false ) {
                // tech & comp sci
                CategoryCourseList(categoryName: "Technology & Computer Science")
                
                CategoryCourseList(categoryName: "Psychology")
                
                CategoryCourseList(categoryName: "Health & Medicine")
                
                CategoryCourseList(categoryName: "History & Social Science")
                
                CategoryCourseList(categoryName: "Math & Physics")
                
                CategoryCourseList(categoryName: "Business & Economic")
                
                CategoryCourseList(categoryName: "Philosophy & Ethics")
                
                
                Spacer()
                
                BottomBrandView()
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CuratedCoursesFullList()
}
