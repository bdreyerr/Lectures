//
//  SearchBarWithFilters.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/28/24.
//

import SwiftUI

struct SearchBarWithFilters: View {
    @State var isFilterShowing: Bool = false
    
    var body: some View {
        // Search Bar
        HStack {
            // Search Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            TextField("Search Course", text: .constant(""))
                .foregroundColor(.black)
                .font(.system(size: 14, design: .serif))
                .tint(.black)
                .textFieldStyle(PlainTextFieldStyle())
            
            Spacer()
            
            // Filter Icon
            Image(systemName: "slider.horizontal.3")
                .foregroundColor(.black)
                .onTapGesture {
                    isFilterShowing.toggle()
                }
            
            // Submit Button
            Button(action: {
                // Add your search submit logic here
                print("Search submitted")
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.orange)
                    .padding()
            }
            .buttonStyle(PlainButtonStyle()) // Avoid default button style
            
        }
        .padding(10)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        
        // If filter box is showing
        if isFilterShowing {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Filters")
                        .font(.system(size: 16, design: .serif))
                        .bold()
                    
                    Spacer()
                }
                
                // Course Category
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category")
                        .font(.system(size: 14, design: .serif))
                    HStack {
                        ForEach(["STEM", "Humanities", "Business"], id: \.self) { category in
                            FilterChip(text: category, isSelected: .constant(false))
                        }
                    }
                }
                
                // Course Size
                VStack(alignment: .leading, spacing: 8) {
                    Text("Course Size")
                        .font(.system(size: 14, design: .serif))
                    HStack {
                        ForEach(["< 10 lectures", "10-20 lectures", "20+ lectures"], id: \.self) { size in
                            FilterChip(text: size, isSelected: .constant(false))
                        }
                    }
                }
                
                // Sort By
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sort By")
                        .font(.system(size: 14, design: .serif))
                    HStack {
                        ForEach(["Most Views", "Newest", "Most Likes"], id: \.self) { sort in
                            FilterChip(text: sort, isSelected: .constant(false))
                        }
                    }
                }
            }
            .padding(15)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
        }
    }
}

#Preview {
    SearchBarWithFilters()
}
