//
//  FeaturedCourse.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct FeaturedCourse: View {
    @State private var isLiked = false
    var image: String
    var courseTitle: String
    var courseDescriptor: String
    var length: String
    var numViews: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Image(image) // Replace with your own image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.15)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
            
            Text(courseTitle)
                .font(.system(size: 18, design: .serif))
                .bold()
            
            HStack {
                Text(courseDescriptor)
                    .font(.system(size: 12, design: .serif))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .secondary)
                }
            }
        }

    }
}

#Preview {
    FeaturedCourse(image: "mit", courseTitle: "Society of Mind", courseDescriptor: "MIT - Marvin Minsky", length: "1hr 6min", numViews: "2.5M")
}
