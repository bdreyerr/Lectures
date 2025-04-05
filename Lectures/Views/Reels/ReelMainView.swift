//
//  ReelMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 3/9/25.
//

import SwiftUI
import AVKit

struct ReelMainView: View {
    @EnvironmentObject var rateLimiter: RateLimiter
    @EnvironmentObject var courseController: CourseController
    
    @StateObject private var reelsController = ReelsController()
    @State private var dragOffset: CGFloat = 0
    @State private var dragThreshold: CGFloat = 100
    @State private var isTransitioning: Bool = false
    @State private var transitionDirection: TransitionDirection = .none
    @State private var nextIndex: Int? = nil
    @State private var animationProgress: CGFloat = 0
    @State private var completingTransition: Bool = false
    @State private var initialDragOffset: CGFloat = 0
    
    // Animation timing constants
    private let transitionDuration: Double = 0.3
    private let completionDelay: Double = 0.2
    
    enum TransitionDirection {
        case up, down, none
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    // Loading indicator
                    if reelsController.isLoading {
                        ZStack {
                            // Show a blurred version of the previous video or a placeholder
                            if let currentReel = currentReel {
                                // You could show a cached thumbnail here
                                Rectangle()
                                    .fill(Color.black)
                                    .opacity(0.7)
                            }
                            
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.5)
                                
                                Text("Loading...")
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                            }
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.3), value: reelsController.isLoading)
                    } else if reelsController.reels.isEmpty {
                        // No reels available
                        VStack {
                            Image(systemName: "video.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            
                            Text("No reels available")
                                .foregroundColor(.white)
                                .padding(.top, 20)
                        }
                    } else {
                        // Next Video Player (shown during transition)
                        if let nextIdx = nextIndex, nextIdx >= 0, nextIdx < reelsController.reels.count, 
                            let nextPlayer = reelsController.playerAt(index: nextIdx), let nextReel = reelsController.reelAt(index: nextIdx) {
                            
                            // Next video container with UI - properly centered
                            VStack(spacing: 0) {
                                Spacer()
                                
                                // Video container with fixed aspect ratio
                                ZStack {
                                    VStack {
                                        if let player = reelsController.playerAt(index: nextIdx) {
                                            VideoPlayer(player: player)
                                                .aspectRatio(16/9, contentMode: .fit)
                                                .frame(width: geometry.size.width)
                                                // .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .disabled(true) // Disable video player controls but allow hit testing
                                        }
                                    }
                                    .padding(.bottom, 50)
                                    
                                    // Overlay UI for next video
                                    VStack {
                                        // Add more space at the top to push content down
                                        Spacer()
                                        
                                        // Video Info at bottom
                                        HStack(alignment: .bottom) {
                                            // Left side - Video information
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("@\(nextReel.channelName ?? "Channel")")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                
                                                Text(nextReel.lectureName ?? "Reel Title")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .fontWeight(.bold)
                                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                
                                                Text(nextReel.courseName ?? "Reel description")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .lineLimit(2)
                                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                            }
                                            .padding(.horizontal)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            // Right side - Action buttons
                                            VStack(spacing: 20) {
//                                                // Profile button
//                                                Button(action: {}) {
//                                                    VStack {
//                                                        Image(systemName: "person.circle.fill")
//                                                            .resizable()
//                                                            .scaledToFit()
//                                                            .frame(width: 40, height: 40)
//                                                            .foregroundColor(.white)
//                                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
//                                                    }
//                                                }
                                                
                                                // Like button
                                                Button(action: {
                                                    print("tapping like")
                                                }) {
                                                    VStack {
                                                        Image(systemName: nextReel.id != nil && reelsController.isReelLiked(reelId: nextReel.id!) ? "heart.fill" : "heart")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .foregroundColor(nextReel.id != nil && reelsController.isReelLiked(reelId: nextReel.id!) ? .red : .white)
                                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                                                        
                                                        Text("\(nextReel.likes)")
                                                            .foregroundColor(.white)
                                                            .font(.caption)
                                                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                    }
                                                }
                                                
                                                // Share button
                                                Button(action: {}) {
                                                    VStack {
                                                        Image(systemName: "arrowshape.turn.up.right.fill")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 30, height: 30)
                                                            .foregroundColor(.white)
                                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                                                        
                                                        Text("\(nextReel.shares)")
                                                            .foregroundColor(.white)
                                                            .font(.caption)
                                                            .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                    }
                                                }
                                            }
                                            .padding(.trailing, 20)
                                            .padding(.bottom, 0)
                                        }
                                        
                                        // Add padding at the bottom to move content up
                                        Spacer()
                                            .frame(height: geometry.size.height * 0.12)
                                    }
                                    .zIndex(10)
                                }
                                
                                Spacer()
                            }
                            .frame(maxHeight: .infinity)
                            .offset(y: nextVideoOffset(for: geometry))
                            .zIndex(completingTransition ? 2 : 0) // Bring to front during completion
                            .onAppear {
                                // Start preloading the video and play it immediately at low volume
                                // This ensures it's ready to go when needed
                                nextPlayer.volume = 0
                                nextPlayer.play()
                                nextPlayer.pause()
                            }
                        }
                        
                        // Current Video Player with UI
                        if let player = reelsController.playerForCurrentReel(), let currentReel = currentReel {
                            VStack(spacing: 0) {
                                Spacer()
                                
                                // Video container with fixed aspect ratio
                                ZStack {
                                    VStack {
                                        if let currentPlayer = reelsController.playerForCurrentReel() {
                                            VideoPlayer(player: currentPlayer)
                                                .aspectRatio(16/9, contentMode: .fit)
                                                .frame(width: geometry.size.width)
                                                // .clipShape(RoundedRectangle(cornerRadius: 12))
                                                .disabled(true) // Disable video player controls but allow hit testing
                                        }
                                    }
                                    .padding(.bottom, 50)
                                    
                                    // Overlay UI
                                    VStack {
                                        // Add more space at the top to push content down
                                        Spacer()
                                        
                                        // Video Info at bottom
                                        HStack(alignment: .bottom) {
                                            // Left side - Video information
                                            VStack(alignment: .leading, spacing: 8) {
                                                if let newReel = reelsController.reelAt(index: reelsController.currentIndex) {
                                                    if let channel = courseController.cachedChannels[newReel.channelId ?? ""] {
                                                        NavigationLink(destination: ChannelView(channel: channel)) {
                                                            Text("@\(newReel.channelName ?? "Channel")")
                                                                .font(.headline)
                                                                .foregroundColor(.white)
                                                                .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                        .simultaneousGesture(TapGesture().onEnded {
                                                            courseController.focusChannel(channel)
                                                        })
                                                        
                                                    }
                                                    
                                                    
                                                    if let course = courseController.cachedCourses[newReel.courseId ?? ""] {
                                                        NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                                                            VStack(alignment: .leading, spacing: 8) {
                                                                Text(currentReel.courseName ?? "Reel title")
                                                                    .font(.subheadline)
                                                                    .foregroundColor(.white)
                                                                    .fontWeight(.bold)
                                                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                                
                                                                Text(currentReel.lectureName ?? "Reel description")
                                                                    .font(.caption)
                                                                    .foregroundColor(.white)
                                                                    .lineLimit(2)
                                                                    .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                            }
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                        .simultaneousGesture(TapGesture().onEnded {
                                                            courseController.getCourseThumbnail(courseId: course.id ?? "")
                                                            courseController.focusCourse(course)
                                                        })
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            // Right side - Action buttons
                                            VStack(spacing: 20) {
                                                // Profile button
                                                if let newReel = reelsController.reelAt(index: reelsController.currentIndex) {
                                                    if let channel = courseController.cachedChannels[newReel.channelId ?? ""] {
                                                        if let thumbnail = courseController.channelThumbnails[channel.id ?? ""] {
                                                            NavigationLink(destination: ChannelView(channel: channel)) {
                                                                VStack {
                                                                    Image(uiImage: thumbnail)
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: 40, height: 40)
                                                                        .foregroundColor(.white)
                                                                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                                                                }
                                                            }
                                                            .buttonStyle(PlainButtonStyle())
                                                            .simultaneousGesture(TapGesture().onEnded {
                                                                courseController.focusChannel(channel)
                                                            })
                                                        }
                                                    }
                                                    
                                                    // Like button
                                                    Button(action: {
                                                        // Rate limiting
                                                        if let rateLimit = rateLimiter.processWrite() {
                                                            print(rateLimit)
                                                            return
                                                        }
                                                        
                                                        reelsController.toggleLike()
                                                    }) {
                                                        VStack {
                                                            Image(systemName: currentReel.id != nil && reelsController.isReelLiked(reelId: currentReel.id!) ? "heart.fill" : "heart")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 30, height: 30)
                                                                .foregroundColor(currentReel.id != nil && reelsController.isReelLiked(reelId: currentReel.id!) ? .red : .white)
                                                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                                                            
                                                            Text("\(currentReel.likes)")
                                                                .foregroundColor(.white)
                                                                .font(.caption)
                                                                .shadow(color: .black, radius: 2, x: 1, y: 1)
                                                        }
                                                    }
                                                    
                                                    // Share button
                                                    if let course = courseController.cachedCourses[newReel.courseId ?? ""] {
                                                        NavigationLink(destination: NewCourse(course: course, isLecturePlaying: false)) {
                                                            VStack {
                                                                Image(systemName: "arrowshape.turn.up.right.fill")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 30, height: 30)
                                                                    .foregroundColor(.white)
                                                                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                                                            }
                                                        }
                                                        .buttonStyle(PlainButtonStyle())
                                                        .simultaneousGesture(TapGesture().onEnded {
                                                            courseController.getCourseThumbnail(courseId: course.id ?? "")
                                                            courseController.focusCourse(course)
                                                        })
                                                    }
                                                }
                                                
                                                
                                            }
                                            .padding(.trailing, 20)
                                            .padding(.bottom, 0)
                                        }
                                        
                                        // Add padding at the bottom to move content up
                                        Spacer()
                                            .frame(height: geometry.size.height * 0.12)
                                    }
                                    .zIndex(10)
                                }
                                
                                Spacer()
                            }
                            .frame(maxHeight: .infinity)
                            .offset(y: currentVideoOffset(for: geometry))
                            .zIndex(completingTransition ? 0 : 1) // Send to back during completion
                            .opacity(completingTransition ? 0 : 1) // Fade out during completion
                            .onAppear {
                                reelsController.playCurrentVideo()
                                
                                // Reset loading state after a delay if it gets stuck
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                    reelsController.resetLoadingState()
                                }
                                
                                // TODO: When a new real loads, we need to fetch the associated channel and course using course controller
                                if let newReel = reelsController.reelAt(index: reelsController.currentIndex) {
                                    if let courseId = newReel.courseId, let channelId = newReel.channelId {
                                        courseController.retrieveCourse(courseId: courseId)
                                        courseController.retrieveChannel(channelId: channelId)
                                        courseController.getChannelThumbnail(channelId: channelId)
                                    }
                                }
                            }
                            .onDisappear {
                                reelsController.pauseCurrentVideo()
                            }
                        }
                        
                        // Swipe indicators
                        VStack {
                            if dragOffset > 0 && !isTransitioning {
                                HStack {
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.white)
                                        .opacity(min(dragOffset / dragThreshold, 1.0))
                                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                                    Text("Previous video")
                                        .foregroundColor(.white)
                                        .opacity(min(dragOffset / dragThreshold, 1.0))
                                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                                }
                                .padding(.top, 50)
                            } else if dragOffset < 0 && !isTransitioning {
                                Spacer()
                                HStack {
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(.white)
                                        .opacity(min(-dragOffset / dragThreshold, 1.0))
                                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                                    Text("Next video")
                                        .foregroundColor(.white)
                                        .opacity(min(-dragOffset / dragThreshold, 1.0))
                                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                                }
                                .padding(.bottom, geometry.size.height * 0.15 + 50)
                            }
                            Spacer()
                        }
                        .zIndex(10) // Ensure indicators are above video players
                        .allowsHitTesting(false) // Disable interaction with indicators
                        
                        // Combined gesture overlay - only enable when not loading
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .edgesIgnoringSafeArea(.all)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if !isTransitioning {
                                            dragOffset = value.translation.height
                                        }
                                    }
                                    .onEnded { value in
                                        if !isTransitioning {
                                            if dragOffset > dragThreshold {
                                                // Swiped down - go to previous
                                                if reelsController.currentIndex > 0 {
                                                    // Store the current drag position to continue from
                                                    initialDragOffset = dragOffset
                                                    performTransition(direction: .down, geometry: geometry)
                                                } else {
                                                    // Bounce back if at first video
                                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                        dragOffset = 0
                                                    }
                                                }
                                            } else if dragOffset < -dragThreshold {
                                                // Swiped up - go to next
                                                if reelsController.currentIndex < reelsController.reels.count - 1 {
                                                    // Store the current drag position to continue from
                                                    initialDragOffset = dragOffset
                                                    performTransition(direction: .up, geometry: geometry)
                                                } else {
                                                    // Bounce back if at last video
                                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                        dragOffset = 0
                                                    }
                                                }
                                            } else {
                                                // Not enough to trigger change, bounce back
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                    }
                            )
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded {
                                        // Only handle tap if it's not on a button
                                        reelsController.togglePlayPause()
                                    }
                            )
                            .allowsHitTesting(!reelsController.isLoading)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func currentVideoOffset(for geometry: GeometryProxy) -> CGFloat {
        if isTransitioning {
            // Calculate how far we need to go from the initial drag position
            let targetOffset = transitionDirection == .up ? -geometry.size.height : geometry.size.height
            let remainingDistance = targetOffset - initialDragOffset
            
            // Start from the initial drag position and move the remaining distance based on progress
            return initialDragOffset + (remainingDistance * animationProgress)
        } else {
            // During drag, just follow the finger
            return dragOffset
        }
    }
    
    private func nextVideoOffset(for geometry: GeometryProxy) -> CGFloat {
        if isTransitioning {
            // For next video, start from opposite direction and move in
            let startPosition = transitionDirection == .up ? 
                geometry.size.height : // Start from bottom when swiping up
                -geometry.size.height  // Start from top when swiping down
            
            // Move toward center as animation progresses
            return startPosition * (1 - animationProgress)
        }
        return 0
    }
    
    private func performTransition(direction: TransitionDirection, geometry: GeometryProxy) {
        // Set up transition state
        isTransitioning = true
        transitionDirection = direction
        animationProgress = 0
        completingTransition = false
        
        // Determine the next index
        nextIndex = direction == .up ? 
            reelsController.currentIndex + 1 : 
            reelsController.currentIndex - 1
        
        // Prepare the next video but don't play it yet
        if let nextIdx = nextIndex {
            reelsController.preparePlayerAt(index: nextIdx)
        }
        
        // Animate the transition - faster animation
        withAnimation(.easeInOut(duration: transitionDuration)) {
            animationProgress = 1.0
        }
        
        // Before the animation completes, start playing the next video
        // and mark that we're in the completion phase
        DispatchQueue.main.asyncAfter(deadline: .now() + completionDelay) {
            if let nextIdx = nextIndex {
                // Start playing the next video while the current one is still visible
                // but almost off-screen
                reelsController.playPlayerAt(index: nextIdx)
                
                // Mark that we're in the completion phase to adjust z-index
                withAnimation(.easeInOut(duration: 0.1)) {
                    completingTransition = true
                }
            }
        }
        
        // After the animation completes, switch to the new video
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration) {
            if let nextIdx = nextIndex {
                // Update the current index in the controller
                reelsController.setCurrentIndex(to: nextIdx)
                
            
                // TODO: When a new real loads, we need to fetch the associated channel and course using course controller
                if let newReel = reelsController.reelAt(index: nextIdx) {
                    if let courseId = newReel.courseId, let channelId = newReel.channelId {
                        courseController.retrieveCourse(courseId: courseId)
                        courseController.retrieveChannel(channelId: channelId)
                        courseController.getChannelThumbnail(channelId: channelId)
                    }
                }
                
                
                
                // TODO: Add logic to load more reels if we are at the end of the current reels array in the controller
            }
            
            // Reset states
            dragOffset = 0
            initialDragOffset = 0
            isTransitioning = false
            transitionDirection = .none
            animationProgress = 0
            completingTransition = false
            nextIndex = nil
        }
    }
    
    private var currentReel: Reel? {
        guard reelsController.currentIndex < reelsController.reels.count else { return nil }
        return reelsController.reels[reelsController.currentIndex]
    }
}

#Preview {
    ReelMainView()
}
