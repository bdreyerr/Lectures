//
//  PreviouslyWatchedCourseCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct PreviouslyWatchedLectureCard: View {
    var image: String
    var duration: Double
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(image)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
            
            // Add semi-transparent gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Scociety of Mind")
                            .font(.system(size: 18, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("MIT - Marvin Minsky")
                            .font(.system(size: 14, design: .serif))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(Color(hue: 0.001, saturation: 0.95, brightness: 0.973))
                        )
                }
                .padding()
                
                // progress bar
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width * duration, height: 3) // 30% progress
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 3)
                .padding(.horizontal, 11)
            }
            .padding(.bottom, 1)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
        .shadow(radius: 2.5)
    }
}

#Preview {
    PreviouslyWatchedLectureCard(image: "mit", duration: 0.2)
}
