//
//  ChannelCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import SwiftUI

struct ChannelCard: View {
    @EnvironmentObject var homeController: HomeController
    
    var channel: Channel
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = homeController.channelThumbnails[channel.id!] {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200)
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
                        
//                        HStack {
//                            Text("\(channel.numCourses!) Courses")
//                                .font(.system(size: 14, design: .serif))
//                                .foregroundColor(.white.opacity(0.8))
//                            Text("\(channel.numLectures!) Lectures")
//                                .font(.system(size: 14, design: .serif))
//                                .foregroundColor(.white.opacity(0.8))
//                        }
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
    ChannelCard(channel: Channel())
        .environmentObject(HomeController())
}
