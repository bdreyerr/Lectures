///
//  Categories.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct Categories: View {
    let categories = ["Math", "Science", "Engineering", "Writing", "History", "Literature", "Philosophy", "Economics", "Business", "Computer Science", "Biology", "Chemistry", "Physics", "Sociology", "Psychology", "Art", "Music", "Language", "Geography", "Law"]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("Categories")
                    .font(.system(size: 20, design: .serif))
                    .bold()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryPill(title: category)
                        }
                    }
                }
            }
        }
}

// Category Pill View
struct CategoryPill: View {
    let title: String
    @State var isSelected: Bool = false
    
    var body: some View {
        Text(title)
            
            .font(.system(size: 12, design: .serif))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 1)
            )
            .background(isSelected ? Color(hue: 0.124, saturation: 0.961, brightness: 0.956) : Color.clear)
            .cornerRadius(20)
            
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

#Preview {
    Categories()
}
