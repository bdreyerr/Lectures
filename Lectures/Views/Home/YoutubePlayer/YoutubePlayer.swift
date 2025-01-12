//
//  YoutubePlayer.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/9/25.
//

import SwiftUI
import YouTubePlayerKit

struct YoutubePlayer: View {
    
    @StateObject var youtubePlayerController = YouTubePlayerController()
    var body: some View {
        VStack {
            Button(action: {
                youtubePlayerController.changeSource(url: "https://www.youtube.com/watch?v=-pb3z2w9gDg&list=PLUl4u3cNGP61E-vNcDV0w5xpsIBYNJDkU&ab_channel=MITOpenCourseWare")
            }) {
                Text("Play minsky video")
            }
            
            
            YouTubePlayerView(youtubePlayerController.player) { state in
                // Overlay ViewBuilder closure to place an overlay View
                // for the current `YouTubePlayer.State`
                switch state {
                case .idle:
                    ProgressView()
                case .ready:
                    EmptyView()
                case .error(let error):
                    Text(verbatim: "YouTube player couldn't be loaded: \(error)")
                }
            }
            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
        }
        .environmentObject(youtubePlayerController)
    }
}

#Preview {
    YoutubePlayer()
        .environmentObject(YouTubePlayerController())
}
