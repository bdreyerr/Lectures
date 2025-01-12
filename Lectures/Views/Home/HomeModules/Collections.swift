//
//  Collections.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/9/25.
//

import SwiftUI

struct Collections: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                
                SingleCollectionCard(image: "cs3", titleText: "Introductory Computer Science", subText: "Freshman CS at Top Tech Schools")
                
                SingleCollectionCard(image: "humanities1", titleText: "Humanities Essentials", subText: "Mind Bending Psychology, Literature and More")
                
                SingleCollectionCard(image: "math1", titleText: "Ultimate Math", subText: "High Complexity Math to Break your Brain")
            }
        }
    }
}

struct SingleCollectionCard : View {
    var image: String
    var titleText: String
    var subText: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(image)
                .resizable()
                .frame(width: 200, height: 200)
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // Add semi-transparent gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.75)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(titleText)
                            .font(.system(size: 16, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text(subText)
                                .font(.system(size: 12, design: .serif))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        
                    }
                    Spacer()
                }
                .padding()
            }
            .padding(.bottom, 1)
            
        }
        .frame(width: 200, height: 200)
        .shadow(radius: 2.5)
    }
}

#Preview {
    Collections()
}
