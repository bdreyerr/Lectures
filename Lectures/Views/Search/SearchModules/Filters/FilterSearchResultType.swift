//
//  FilterSearchResultType.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/19/25.
//

import SwiftUI

struct FilterSearchResultType: View {
    @EnvironmentObject var searchController: SearchController
    
    
    var body: some View {
        // Lecture
        Button(action: {
            // Action for the button
            withAnimation(.spring()) {
                searchController.isLectureFilterSelected.toggle()
            }
        }) {
            HStack {
                Image(systemName: "newspaper")
                    .font(.system(size: 11, weight: .medium))
                
                Text("Lecture")
                    .font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background( searchController.isLectureFilterSelected ? Color.orange.opacity(0.6) : Color(UIColor.systemGray5))
            .foregroundColor(.primary)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle()) // To prevent default button styling
        
        // Course
        Button(action: {
            // Action for the button
            withAnimation(.spring()) {
                searchController.isCourseFilterSelected.toggle()
            }
        }) {
            HStack {
                Image(systemName: "mail.stack")
                    .font(.system(size: 11, weight: .medium))
                
                Text("Course")
                    .font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background( searchController.isCourseFilterSelected ? Color.orange.opacity(0.6) : Color(UIColor.systemGray5))
            .foregroundColor(.primary)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle()) // To prevent default button styling
        
        // Channel
        Button(action: {
            // Action for the button
            withAnimation(.spring()) {
                searchController.isChannelFilterSelected.toggle()
            }
        }) {
            HStack {
                Image(systemName: "graduationcap")
                    .font(.system(size: 11, weight: .medium))
                
                Text("Channel")
                    .font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background( searchController.isChannelFilterSelected ? Color.orange.opacity(0.6) : Color(UIColor.systemGray5))
            .foregroundColor(.primary)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle()) // To prevent default button styling
    }
}

#Preview {
    FilterSearchResultType()
}
