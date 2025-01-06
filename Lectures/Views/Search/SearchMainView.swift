//
//  SearchMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct SearchMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
            VStack {
                TopBrandView()
                    .padding(.horizontal, 20)
                
                
                ScrollView() {
                    
                    HStack {
                        Text("Find a course -")
                            .font(.system(size: 20, design: .serif))
                            .bold()
                            .padding(.bottom, 2)
                        
                        Spacer()
                        
                        // Replace previous Text with this version
                        Text(displayedText)
                            .font(.system(size: 18, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                    }
                    .padding(.horizontal, 20)
                    
                    SearchBarWithFilters()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    
                    SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "The Emotion Machine", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    
                    SearchedCourse(coverImage: "stanford", universityImage: "mit", courseName: "The Emotion Machine", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    
                    SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "Another One For Ya", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarHidden(true)
            
        }
    }
}

// Add this helper view for filter chips
struct FilterChip: View {
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, design: .serif))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.black : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 0.5)
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

#Preview {
    SearchMainView()
}
