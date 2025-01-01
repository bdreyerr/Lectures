//
//  NewLectureView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct NewLectureView: View {
    var images = ["mit", "stanford", "scu"]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(images.randomElement() ?? "mit")
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
                        
                        Text("MIT · 9 Lectures · 8hrs")
                            .font(.system(size: 14, design: .serif))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    
//                    Circle()
//                        .fill(Color.white)
//                        .frame(width: 40, height: 40)
//                        .overlay(
//                            Image(systemName: "play.fill")
//                                .foregroundColor(Color(hue: 0.001, saturation: 0.95, brightness: 0.973))
//                        )
                }
                .padding()
            }
            .padding(.bottom, 1)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
        .shadow(radius: 2.5)
    }
}

#Preview {
    NewLectureView()
}
