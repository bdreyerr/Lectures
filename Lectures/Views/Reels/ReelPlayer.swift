//
//  ReelPlayer.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/22/25.
//

import SwiftUI
import YouTubePlayerKit

struct ReelPlayer: View {
    // Store URLs instead of players
    @State private var videoURLs = [
        "https://www.youtube.com/watch?v=MEUh_y1IFZY",  // Previous video
        "https://www.youtube.com/watch?v=0cf-qdZ7GbA",  // Current video
        "https://www.youtube.com/watch?v=MEUh_y1IFZY"   // Next video
    ]
    
    // Create three separate player instances
    @StateObject private var previousPlayer = YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v=MEUh_y1IFZY")
    @StateObject private var currentPlayer = YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v=0cf-qdZ7GbA")
    @StateObject private var nextPlayer = YouTubePlayer(stringLiteral: "https://www.youtube.com/watch?v=MEUh_y1IFZY")
    
    @State private var currentIndex = 1  // Start with middle video
    @State private var dragOffset: CGFloat = 0
    
    // Timer for checking video position
    @State private var timer: Timer?
    
    // Add state for tracking size
    @State private var viewSize: CGSize = .zero
    
    var numSecondsInLoop: Double = 10.0  // Duration of the loop
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Next player (bottom layer)
                YouTubePlayerView(nextPlayer) { state in
                    handlePlayerState(state)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                .offset(y: dragOffset < 0 ? geometry.size.height + (dragOffset * 3) : geometry.size.height)
                .animation(.spring(response: 0.3), value: dragOffset)
                
                // Previous player (middle layer)
                YouTubePlayerView(previousPlayer) { state in
                    handlePlayerState(state)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                .offset(y: dragOffset > 0 ? (dragOffset * 3) - geometry.size.height : -geometry.size.height)
                .animation(.spring(response: 0.3), value: dragOffset)
                
                // Current player (top layer)
                YouTubePlayerView(currentPlayer) { state in
                    handlePlayerState(state)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.35)
                .offset(y: dragOffset * 3)
                .animation(.spring(response: 0.3), value: dragOffset)
                
                // Overlay buttons on right side
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            // Profile Picture
                            Button(action: {
                                // Profile action
                            }) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            
                            // Like Button
                            Button(action: {
                                // Like action
                            }) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                            
                            // Share Button
                            Button(action: {
                                // Share action
                            }) {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 20)
                    }
                    .padding(.bottom, 200) // Reduced from 100 to 50 to move buttons up
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.height
                    }
                    .onEnded { gesture in
                        let threshold: CGFloat = 50  // Reduced from previous value
                        withAnimation(.spring(response: 0.3)) {
                            if gesture.translation.height < -threshold {
                                // Swipe up - next video
                                switchToNextVideo()
                            } else if gesture.translation.height > threshold {
                                // Swipe down - previous video
                                switchToPreviousVideo()
                            }
                            dragOffset = 0
                        }
                    }
            )
            .onAppear {
                viewSize = geometry.size
                configurePlayer(previousPlayer)
                configurePlayer(currentPlayer)
                configurePlayer(nextPlayer)
                
                // Start timer to check video position
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    Task {
                        do {
                            let currentTime = try await currentPlayer.getCurrentTime()
                            if currentTime.value >= numSecondsInLoop {  // Check if we've reached the loop point
                                try? await currentPlayer.seek(to: Measurement(value: 0, unit: .seconds))
                            }
                        } catch {
                            print("Error getting current time: \(error)")
                        }
                    }
                }
            }
            .onChange(of: geometry.size) { newSize in
                viewSize = newSize
            }
            .onChange(of: currentPlayer.state?.isReady) {
                print("player ready")
                currentPlayer.seek(to: Measurement(value: 0, unit: .seconds))
            }
            .onDisappear {
                // Clean up timer when view disappears
                timer?.invalidate()
                timer = nil
            }
        }
        .ignoresSafeArea() // Makes the player truly full screen
    }
    
    private func configurePlayer(_ player: YouTubePlayer) {
        player.configuration = .init(
            allowsPictureInPictureMediaPlayback: false,
            autoPlay: true,
            showCaptions: false,
            showControls: false,
            showAnnotations: false,
            useModestBranding: true,
            showRelatedVideos: false
        )
        
        // Start playing immediately
        Task {
            try? await player.play()
            try? await player.seek(to: Measurement(value: 0, unit: .seconds))
        }
    }
    
    private func handlePlayerState(_ state: YouTubePlayer.State) -> some View {
        switch state {
        case .idle:
            return AnyView(ProgressView())
        case .ready:
            return AnyView(EmptyView())
        case .error(let error):
            return AnyView(Text(verbatim: "Error loading video: \(error)"))
        }
    }
    
    private func switchToNextVideo() {
        videoURLs.rotate(toStartOfArray: 1)
        previousPlayer.source = .url(URL(string: videoURLs[0])!)
        currentPlayer.source = .url(URL(string: videoURLs[1])!)
        nextPlayer.source = .url(URL(string: videoURLs[2])!)
        currentIndex = 1
        
        // Just seek to start instead of reloading
        Task {
            try? await previousPlayer.seek(to: Measurement(value: 0, unit: .seconds))
            try? await currentPlayer.seek(to: Measurement(value: 0, unit: .seconds))
            try? await nextPlayer.seek(to: Measurement(value: 0, unit: .seconds))
        }
    }
    
    private func switchToPreviousVideo() {
        videoURLs.rotate(toStartOfArray: -1)
        previousPlayer.source = .url(URL(string: videoURLs[0])!)
        currentPlayer.source = .url(URL(string: videoURLs[1])!)
        nextPlayer.source = .url(URL(string: videoURLs[2])!)
        currentIndex = 1
        
        // Just seek to start instead of reloading
        Task {
            try? await previousPlayer.seek(to: Measurement(value: 0, unit: .seconds))
            try? await currentPlayer.seek(to: Measurement(value: 0, unit: .seconds))
            try? await nextPlayer.seek(to: Measurement(value: 0, unit: .seconds))
        }
    }
}

// Helper extension to rotate array
extension Array {
    mutating func rotate(toStartOfArray n: Int) {
        guard !isEmpty else { return }
        let n = n % count
        let p = (n < 0) ? (n + count) : n
        self = Array(self[p...] + self[..<p])
    }
}
