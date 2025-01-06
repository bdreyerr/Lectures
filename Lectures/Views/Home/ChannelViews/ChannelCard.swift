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
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                // default image when not loaded
                Image("google_logo")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 150)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
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
                        Text(channel.title!)
                            .font(.system(size: 18, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("\(channel.numCourses!) Courses")
                                .font(.system(size: 14, design: .serif))
                                .foregroundColor(.white.opacity(0.8))
                            Text("\(channel.numLectures!) Lectures")
                                .font(.system(size: 14, design: .serif))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    Spacer()
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
    ChannelCard(channel: Channel())
        .environmentObject(HomeController())
}
