//
//  SkeletonLoaders.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/7/25.
//

import SwiftUI

struct SkeletonLoader: View {
    @State private var isAnimating = false
    
    var width: CGFloat
    var height: CGFloat
    
    init(width: CGFloat = 200, height: CGFloat = 20) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: width, height: height)
                .cornerRadius(8)
            
            // Shimmer effect
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .white.opacity(0.4), location: 0.3),
                            .init(color: .white.opacity(0.4), location: 0.7),
                            .init(color: .clear, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: width * 0.8) // Make gradient width smaller for smoother animation
                .offset(x: isAnimating ? width : -width)
                .animation(
                    Animation.linear(duration: 1.2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
        .clipped()
    }
}

#Preview {
    SkeletonLoader()
}
