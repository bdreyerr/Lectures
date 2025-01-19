//
//  SearchResultTypePill.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct SearchResultTypePill: View {
    
    var iconName: String
    var text: String
    
    @State private var isSelected: Bool = true
    var body: some View {
        Button(action: {
            // Action for the button
            withAnimation(.spring()) {
                isSelected.toggle()
            }
        }) {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 11, weight: .medium))
                
                Text(text)
                    .font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background( isSelected ? Color.orange.opacity(0.6) : Color(UIColor.systemGray5))
            .foregroundColor(.primary)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle()) // To prevent default button styling
    }
}

//#Preview {
//    SearchResultTypePill()
//}
