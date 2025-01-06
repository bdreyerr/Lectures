//
//  CategoryCourseList.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct CategoryCourseList: View {
    var categoryName: String
    var body: some View {
        HStack {
            Text(categoryName)
                .font(.system(size: 20, design: .serif))
                .bold()
            Spacer()
        }
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
//                NavigationLink(destination: CourseView()) {
//                    NewLectureView()
//                }
//                .buttonStyle(PlainButtonStyle())
//                
//                NavigationLink(destination: CourseView()) {
//                    NewLectureView()
//                }
//                .buttonStyle(PlainButtonStyle())
//                
//                NavigationLink(destination: CourseView()) {
//                    NewLectureView()
//                }
//                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    CategoryCourseList(categoryName: "String Theory")
}
