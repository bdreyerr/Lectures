//
//  SearchedCourse.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/28/24.
//

import SwiftUI

struct SearchedCourse: View {
    @State private var isLiked = false
    var coverImage: String
    var universityImage: String
    var courseName: String
    var universityName: String
    var numLectures: Int
    var watchTimeinHrs: Int
    var totalViews: String
    
    var body: some View {
        // A single course showing up in the search results
        // start with the image
        Image(coverImage)
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: 220)
        
        // Then the info
        HStack {
            // University Photo
            Image(universityImage)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(width: 40, height: 40)
            
            VStack {
                // Course Name
                Text(courseName)
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text(universityName)
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                    
                    Text("\(numLectures) Lectures")
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                    
                    Text("\(watchTimeinHrs)hr Watch Time")
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                    
                    Text("\(totalViews) Views")
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            // Heart icon
            Button(action: {
                isLiked.toggle()
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .foregroundColor(isLiked ? .red : .secondary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

#Preview {
    SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "The Emotion Machine", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
}
