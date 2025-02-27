//
//  ReelCarosel.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/22/25.
//

import SwiftUI

struct ReelCarosel: View {
    // State to track current index
    @State private var currentIndex: Int = 0
    
    // Sample images - replace with your actual images
    private let images = [
        "lectura-icon",
        "lectura-icon",
        "lectura-icon"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            // Make the frame wider to account for the rotation
            .frame(width: geometry.size.height, height: geometry.size.width)
            .rotationEffect(.degrees(-90), anchor: .topLeading)
            .offset(x: geometry.size.width)
        }
    }
}
