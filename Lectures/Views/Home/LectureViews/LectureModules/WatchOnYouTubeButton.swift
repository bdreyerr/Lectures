//
//  WatchOnYouTubeButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/26/25.
//

import SwiftUI

struct WatchOnYouTubeButton: View {
    let videoUrl: String // Pass the YouTube video ID as an argument
    // Safely construct the URL
    var youtubeURL: URL? {
        URL(string: videoUrl)
    }
    
    var body: some View {
        Button(action: {
            // Safely open the YouTube video if the URL is valid
            if let url = youtubeURL {
                UIApplication.shared.open(url)
            } else {
                print("Invalid YouTube video ID") // Handle the error case
            }
        }) {
            HStack(spacing: 8) {
//                Image("youtube-logo") // Ensure you have an image asset named "youtube-logo"
//                    .resizable()
//                    .frame(width: 20, height: 20)
//                    .foregroundStyle(Color.white)
                
                Text("Watch on YouTube")
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(Color.red)
                    .overlay(
                        Capsule()
                            .strokeBorder(Color.red, lineWidth: 1)
                    )
            )
        }
        .padding(.top, 5)
    }
}

//#Preview {
//    WatchOnYouTubeButton()
//}
