//
//  HomeSearch.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct HomeSearch: View {
    
    // Add these state variables at the top of the struct
    @State private var currentSubject = "cognitive science"
    @State private var displayedText = ""
    @State private var subjects = [
        "cognitive science",
        "differential equations",
        "linear algebra",
        "computer science",
        "organic chemistry"
    ]
    @State private var currentIndex = 0
    @State private var isAnimating = false
    
    // Increased timer interval to allow for typing animation
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    func typeWriter() {
        let typeInterval = 0.05 // Adjust speed of typing
        isAnimating = true
        displayedText = ""
        
        for (index, character) in currentSubject.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + typeInterval * Double(index)) {
                displayedText += String(character)
                if index == currentSubject.count - 1 {
                    isAnimating = false
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Background Rounded Rectangle
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.white.opacity(0.95),
                            Color.gray.opacity(0.1)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 160)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 4)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                // Text Content on the Left
                VStack(alignment: .leading, spacing: 10) {
                    Text("Find a course")
                        .font(.system(size: 20, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    // Replace previous Text with this version
                    Text(displayedText)
                        .font(.system(size: 18, design: .serif))
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.9))
                        .animation(.easeInOut(duration: 0.1), value: displayedText)
                        .onReceive(timer) { _ in
                            if !isAnimating {
                                currentIndex = (currentIndex + 1) % subjects.count
                                currentSubject = subjects[currentIndex]
                                typeWriter()
                            }
                        }
                        .onAppear {
                            typeWriter() // Initial animation
                        }
                    
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
                    }
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                }
                .padding(.leading, 20)
                .padding(.vertical, 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeSearch()
}
