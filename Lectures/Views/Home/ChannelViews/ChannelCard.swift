//
//  ChannelCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import SwiftUI

struct ChannelCard: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var channel: Channel
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = courseController.channelThumbnails[channel.id!] {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 180, height: 180)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                // default image when not loaded
                SkeletonLoader(width: 200, height: 200)
            }
            
            // Add semi-transparent gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(channel.title!)
                            .font(.system(size: 18, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            .padding(.bottom, 1)
        }
        .frame(width: 180, height: 180)
        .shadow(radius: 2.5)
    }
}

#Preview {
    ChannelCard(channel: Channel())
        .environmentObject(HomeController())
}
