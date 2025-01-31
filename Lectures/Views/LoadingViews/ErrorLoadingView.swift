//
//  ErrorLoadingView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/26/25.
//

import SwiftUI

struct ErrorLoadingView: View {
    var body: some View {
        VStack(spacing: 24) {
            // Graphic
            ZStack {
                // Base Circle
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 150, height: 150)
                
                // Sad Face
                VStack(spacing: 8) {
                    // Eyes
                    HStack(spacing: 20) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                    }
                    // Mouth
                    Path { path in
                        path.move(to: CGPoint(x: 40, y: 20))
                        path.addArc(
                            center: CGPoint(x: 40, y: 30),
                            radius: 20,
                            startAngle: Angle(degrees: 0),
                            endAngle: Angle(degrees: 180),
                            clockwise: true
                        )
                    }
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 80, height: 40)
                }
            }
            
            // Message
            Text("Oops! We couldn’t display this page.")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Text("Please check your internet connection or try again later.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ErrorLoadingView()
}
