//
//  YouTubePlayerController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/9/25.
//

import Foundation
import YouTubePlayerKit
import SwiftUICore

class YouTubePlayerController : ObservableObject {
    @ObservedObject var player: YouTubePlayer = ""
    
    init() {
        self.player.configuration.autoPlay = false
//        self.player.configuration.allowsPictureInPictureMediaPlayback = true
//        self.player.configuration.showControls = true
    }
    
    func changeSource(url: String) {
        // if the new url is the same as the already playing url don't do anything
        print(self.player)
        
        self.player.pause()
        
        self.player.source = .url(url)
    }
}
