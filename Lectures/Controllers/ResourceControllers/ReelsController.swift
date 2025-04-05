//
//  ReelsController.swift
//  Lectures
//
//  Created by Ben Dreyer on 3/9/25.
//

import Foundation
import AVFoundation
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseStorage

class ReelsController: NSObject, ObservableObject {
    @Published var reels: [Reel] = []
    @Published var currentIndex: Int = 0
    @Published var isPlaying: Bool = true
    @Published var isLoading: Bool = true
    @Published var likedReels: Set<String> = Set() // Track liked reels by ID
    
    // Replace the players array with a fixed-size array and tracking variables
    private var recycledPlayers: [AVPlayer] = [AVPlayer(), AVPlayer(), AVPlayer()]
    private var playerAssignments: [Int: Int] = [:] // Maps reel index to player index
    private var playerReelIndices: [Int] = [-1, -1, -1] // Tracks which reel index each player is showing
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    // Alternative approach - create a new player for each reel
    private var playerCache: [Int: AVPlayer] = [:]
    
    // Add these properties to the ReelsController class
    private var lastFetchedReelId: String? = nil
    private var isFetchingMoreReels: Bool = false
    private let reelsPerPage: Int = 8
    private var fetchedReelIds: Set<String> = Set() // Track already fetched reels to avoid duplicates
    
    // Add this property to track our random number threshold
    private var currentRandomThreshold: Int = 0
    
    override init() {
        super.init()
        fetchReelsFromFirebase()
    }
    
    private func fetchReelsFromFirebase() {
        isLoading = true
        fetchedReelIds.removeAll() // Clear the set when starting fresh
        lastFetchedReelId = nil
        
        // Generate a random threshold for the initial fetch
        currentRandomThreshold = Int.random(in: 0...999999)
        
        // Fetch the first batch of random reels
        fetchReelsWithRandomThreshold()
    }
    
    private func fetchReelsWithRandomThreshold() {
        guard !isFetchingMoreReels else { return }
        
        isFetchingMoreReels = true
        
        // Show loading indicator only if this is the first fetch
        let shouldShowLoading = reels.isEmpty
        if shouldShowLoading {
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = true
            }
        }
        
        print("Fetching reels with random threshold: \(currentRandomThreshold)")
        
        // Create a query to get reels with randomNumber > our threshold
        let query = db.collection("reels")
                      .whereField("randomNumber", isGreaterThan: currentRandomThreshold)
                      .limit(to: reelsPerPage)
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching reels: \(error.localizedDescription)")
                self.handleEmptyOrErrorResult(shouldShowLoading: shouldShowLoading)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No reels found with randomNumber > \(self.currentRandomThreshold)")
                
                // If no reels found above the threshold, try below the threshold
                self.fetchReelsBelowThreshold(shouldShowLoading: shouldShowLoading)
                return
            }
            
            // Process the documents
            self.processReelDocuments(documents, shouldShowLoading: shouldShowLoading)
        }
    }
    
    private func fetchReelsBelowThreshold(shouldShowLoading: Bool) {
        print("Trying to fetch reels with randomNumber < \(currentRandomThreshold)")
        
        // Create a query to get reels with randomNumber < our threshold
        let query = db.collection("reels")
                      .whereField("randomNumber", isLessThan: currentRandomThreshold)
                      .limit(to: reelsPerPage)
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching reels below threshold: \(error.localizedDescription)")
                self.handleEmptyOrErrorResult(shouldShowLoading: shouldShowLoading)
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("No reels found below threshold either")
                self.handleEmptyOrErrorResult(shouldShowLoading: shouldShowLoading)
                return
            }
            
            // Process the documents
            self.processReelDocuments(documents, shouldShowLoading: shouldShowLoading)
        }
    }
    
    private func handleEmptyOrErrorResult(shouldShowLoading: Bool) {
        defer {
            isFetchingMoreReels = false
        }
        
        // If this is the first fetch and no reels were found, fall back to sample data
        if reels.isEmpty {
            print("Falling back to sample data")
            DispatchQueue.main.async {
                self.reels = Reel.samples
                self.setupPlayers()
                self.isLoading = false
            }
        } else {
            // Otherwise, just end loading
            if shouldShowLoading {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func processReelDocuments(_ documents: [QueryDocumentSnapshot], shouldShowLoading: Bool) {
        defer {
            isFetchingMoreReels = false
        }
        
        print("Fetched \(documents.count) reels")
        
        // Parse documents into Reel objects
        var newReels: [Reel] = []
        
        for document in documents {
            // Skip if we've already fetched this reel
            if self.fetchedReelIds.contains(document.documentID) {
                continue
            }
            
            do {
                var reel = try document.data(as: Reel.self, decoder: Firestore.Decoder())
                
                // Ensure the reel has an ID
                if reel.id == nil {
                    reel.id = document.documentID
                }
                
                // Add to our tracking set
                self.fetchedReelIds.insert(document.documentID)
                newReels.append(reel)
            } catch {
                print("Error decoding reel: \(error.localizedDescription)")
            }
        }
        
        // If we got new reels, download their videos and add them to our list
        if !newReels.isEmpty {
            // First, download videos for the new reels before adding them to the main array
            downloadVideosForNewReels(newReels) { [weak self] in
                guard let self = self else { return }
                
                // Now add the new reels to our existing reels
                DispatchQueue.main.async {
                    let oldCount = self.reels.count
                    self.reels.append(contentsOf: newReels)
                    
                    print("Total reels count now: \(self.reels.count)")
                    
                    if shouldShowLoading {
                        self.isLoading = false
                    }
                }
            }
        } else {
            if shouldShowLoading {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    private func downloadVideosFromStorage() {
        isLoading = true
        let dispatchGroup = DispatchGroup()
        
        // We'll only download the first few videos initially
        let initialLoadCount = min(3, reels.count)
        
        for i in 0..<initialLoadCount {
            let reel = reels[i]
            guard let reelId = reel.id else { continue }
            
            dispatchGroup.enter()
            
            // Create a reference to the video in Firebase Storage
            let videoRef = storage.reference().child("reels/\(reelId).mp4")
            
            // Get the download URL
            videoRef.downloadURL { [weak self] (url, error) in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                
                if let error = error {
                    print("Error getting download URL for reel \(reelId): \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    print("Download URL is nil for reel \(reelId)")
                    return
                }
                
                // Assign this URL to one of our recycled players
                if i < self.recycledPlayers.count {
                    let player = self.recycledPlayers[i]
                    let playerItem = AVPlayerItem(url: downloadURL)
                    player.replaceCurrentItem(with: playerItem)
                    
                    // Set up looping for this player
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player.currentItem,
                        queue: .main) { _ in
                            player.seek(to: CMTime.zero)
                            player.play()
                        }
                    
                    // Track which reel this player is showing
                    self.playerReelIndices[i] = i
                    self.playerAssignments[i] = i
                    
                    // Add this to the player item setup
                    playerItem.preferredForwardBufferDuration = 2.0  // Buffer 2 seconds ahead
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // If we couldn't download any videos, fall back to samples
            if self.playerReelIndices.allSatisfy({ $0 == -1 }) {
                self.reels = Reel.samples
                self.setupSamplePlayers()
            }
            
            self.isLoading = false
        }
    }
    
    private func setupSamplePlayers() {
        // Initialize the recycled players with sample videos
        let sampleCount = min(recycledPlayers.count, reels.count)
        
        for i in 0..<sampleCount {
            if let path = Bundle.main.path(forResource: reels[i].videoURL, ofType: "mp4") {
                let url = URL(fileURLWithPath: path)
                let player = recycledPlayers[i]
                let playerItem = AVPlayerItem(url: url)
                player.replaceCurrentItem(with: playerItem)
                
                // Loop videos
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main) { [weak self] _ in
                        player.seek(to: CMTime.zero)
                        player.play()
                    }
                
                // Track which reel this player is showing
                playerReelIndices[i] = i
                playerAssignments[i] = i
            }
        }
    }
    
    private func setupPlayers() {
        // This method should call setupSamplePlayers since we're falling back to samples
        setupSamplePlayers()
    }
    
    // Add this method to properly dispose of a player
    private func disposePlayer(_ player: AVPlayer) {
        // Stop playback
        player.pause()
        
        // Set volume to 0
        player.volume = 0
        
        // Remove all observers
        NotificationCenter.default.removeObserver(player)
        
        // Remove the current item
        player.replaceCurrentItem(with: nil)
    }
    
    // Add this method to clean up unused players
    private func cleanupUnusedPlayers() {
        // Get the set of indices we need to keep (current and adjacent)
        let indicesToKeep = Set([
            currentIndex,
            currentIndex - 1,
            currentIndex + 1
        ].filter { $0 >= 0 && $0 < reels.count })
        
        // Find indices to remove
        let indicesToRemove = playerCache.keys.filter { !indicesToKeep.contains($0) }
        
        // Dispose and remove players for these indices
        for index in indicesToRemove {
            if let player = playerCache[index] {
//                print("Disposing player for reel \(index)")
                disposePlayer(player)
                playerCache.removeValue(forKey: index)
            }
        }
    }
    
    // Update the playerForReelAt method to clean up unused players
    func playerForReelAt(index: Int) -> AVPlayer? {
        // Clean up unused players periodically
        cleanupUnusedPlayers()
        
        // Check if we already have a player for this reel
        if let existingPlayer = playerCache[index] {
            return existingPlayer
        }
        
        // Create a new player for this reel
        guard index >= 0, index < reels.count else { return nil }
        let reel = reels[index]
        guard let reelId = reel.id else { return nil }
        
//        print("Creating new player for reel \(index)")
        
        // Create a new player
        let player = AVPlayer()
        playerCache[index] = player
        
        // Load the video
        loadVideoForReel(at: index, into: player)
        
        return player
    }
    
    // Modify forceLoadVideoForReel to be more efficient
    private func forceLoadVideoForReel(at reelIndex: Int, into player: AVPlayer) {
        guard reelIndex >= 0, reelIndex < reels.count else { return }
        
        let reel = reels[reelIndex]
        guard let reelId = reel.id else { return }
        
        // Only show loading indicator for the current reel
        let shouldShowLoading = reelIndex == currentIndex
        
        if shouldShowLoading {
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = true
            }
        }
        
        // Remove all observers and reset the player
        NotificationCenter.default.removeObserver(player)
        
        // Try to get the URL first instead of downloading the entire file
        let videoRef = storage.reference().child("reels/\(reelId).mp4")
        
        videoRef.downloadURL { [weak self] (url, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error getting download URL for reel \(reelIndex): \(error.localizedDescription)")
                if shouldShowLoading {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
                return
            }
            
            guard let downloadURL = url else {
                print("Download URL is nil for reel \(reelIndex)")
                if shouldShowLoading {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
                return
            }
            
            // Create AVAsset with custom loading options for better streaming
            let asset = AVAsset(url: downloadURL)
            let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["playable"])
            
            // Set up a timeout for loading
            let timeoutSeconds = 10.0
            DispatchQueue.main.asyncAfter(deadline: .now() + timeoutSeconds) { [weak self] in
                if shouldShowLoading {
                    self?.isLoading = false
                }
            }
            
            // Listen for when the item is ready to play
            playerItem.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
            
            DispatchQueue.main.async {
                // Replace the current item with the new one
                player.replaceCurrentItem(with: playerItem)
                
                // Set up looping for this player
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main) { _ in
                        player.seek(to: CMTime.zero)
                        player.play()
                    }
            }
        }
    }
    
    // Add this method to handle player item status changes
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let playerItem = object as? AVPlayerItem {
            if playerItem.status == .readyToPlay {
                // The item is ready to play
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                }
            } else if playerItem.status == .failed {
                // The item failed to load
                print("Player item failed to load: \(String(describing: playerItem.error))")
                DispatchQueue.main.async { [weak self] in
                    self?.isLoading = false
                }
            }
        }
    }
    
    // Add this method to load a video into a player
    private func loadVideoForReel(at reelIndex: Int, into player: AVPlayer) {
        // Simply call our force loading method since that's the more reliable approach
        forceLoadVideoForReel(at: reelIndex, into: player)
    }
    
    // Modify the assignPlayerToReel method to use our new force loading method
    private func assignPlayerToReel(at reelIndex: Int) -> AVPlayer? {
        guard reelIndex >= 0, reelIndex < reels.count else { return nil }
        
//        print("Assigning player to reel \(reelIndex)")
        
        // Find a player to reuse - simplify this logic
        var playerToReuse = reelIndex % recycledPlayers.count
        
        // Update our tracking
        let oldReelIndex = playerReelIndices[playerToReuse]
        if oldReelIndex != -1 {
            playerAssignments.removeValue(forKey: oldReelIndex)
        }
        
        playerReelIndices[playerToReuse] = reelIndex
        playerAssignments[reelIndex] = playerToReuse
        
        // Force load the video for this reel
        let player = recycledPlayers[playerToReuse]
        forceLoadVideoForReel(at: reelIndex, into: player)
        
        return player
    }
    
    // Replace existing playerForCurrentReel method
    func playerForCurrentReel() -> AVPlayer? {
        return playerForReelAt(index: currentIndex)
    }
    
    // Update existing playCurrentVideo method
    func playCurrentVideo() {
        // First stop all audio to prevent overlap
        stopAllAudio()
        
        // Then pause all videos
        pauseAllVideos()
        
        // Finally play the current video with full volume
        if let player = playerForCurrentReel() {
            player.volume = 1.0
            player.play()
            isPlaying = true
        }
    }
    
    // Update existing pauseCurrentVideo method
    func pauseCurrentVideo() {
        if let player = playerForCurrentReel() {
            player.pause()
            isPlaying = false
        }
    }
    
    // Update existing pauseAllVideos method
    private func pauseAllVideos() {
        // Pause all recycled players
        recycledPlayers.forEach { $0.pause() }
        
        // Also pause all cached players
        for (_, player) in playerCache {
            player.pause()
        }
    }
    
    // Add a method to completely stop all audio
    private func stopAllAudio() {
        // Set volume to 0 for all players
        recycledPlayers.forEach { $0.volume = 0 }
        
        for (_, player) in playerCache {
            player.volume = 0
        }
    }
    
    // Update existing playerAt method
    func playerAt(index: Int) -> AVPlayer? {
        return playerForReelAt(index: index)
    }
    
    // Update existing preparePlayerAt method
    func preparePlayerAt(index: Int) {
        guard index >= 0, index < reels.count else { return }
        
        // Make sure we have a player assigned to this reel
        let player = playerForReelAt(index: index) ?? assignPlayerToReel(at: index)
        
        // Prepare it
        player?.seek(to: CMTime.zero)
        player?.pause()
    }
    
    // Add this method to preload videos beyond just adjacent ones
    private func preloadUpcomingVideos() {
        // Preload the next few videos (not just the adjacent one)
        let preloadCount = 3  // Number of videos to preload ahead
        
        for i in (currentIndex + 1)...(currentIndex + preloadCount) {
            if i < reels.count {
                // Load at low priority
                DispatchQueue.global(qos: .background).async {
                    _ = self.playerForReelAt(index: i)
                }
            }
        }
    }
    
    // Update the setCurrentIndex method to ensure audio is properly set
    func setCurrentIndex(to index: Int) {
        guard index >= 0, index < reels.count else { return }
        
        // Stop audio from all players
        stopAllAudio()
        
        // Update the current index
        currentIndex = index
        
        // Always ensure the current video is loaded and has proper volume
        if let currentPlayer = playerForReelAt(index: index) {
            currentPlayer.volume = 1.0  // Ensure volume is set to full
        }
        
        // Preload adjacent videos but ensure they're muted
        if index > 0 {
            if let prevPlayer = playerForReelAt(index: index - 1) {
                prevPlayer.volume = 0
                prevPlayer.pause()
            }
        }
        
        if index < reels.count - 1 {
            if let nextPlayer = playerForReelAt(index: index + 1) {
                nextPlayer.volume = 0
                nextPlayer.pause()
            }
        }
        
        // Preload more upcoming videos in the background
        preloadUpcomingVideos()
        
        // Clean up any other players
        cleanupUnusedPlayers()
        
        // Check if we need to fetch more reels
        checkAndFetchMoreReelsIfNeeded()
    }
    
    // Update existing playPlayerAt method
    func playPlayerAt(index: Int) {
        // First stop all audio
        stopAllAudio()
        
        // Then pause all videos
        pauseAllVideos()
        
        // Finally play the requested video with full volume
        if let player = playerForReelAt(index: index) {
            player.volume = 1.0
            player.play()
        }
    }
    
    // Toggle like status for the current reel
    func toggleLike() {
        guard currentIndex < reels.count, let reelId = reels[currentIndex].id else { return }
        
        // Check if already liked
        let isCurrentlyLiked = likedReels.contains(reelId)
        
        // Update local state first for immediate feedback
        if isCurrentlyLiked {
            likedReels.remove(reelId)
            reels[currentIndex].likes -= 1
        } else {
            likedReels.insert(reelId)
            reels[currentIndex].likes += 1
        }
        
        // Update Firestore
        updateReelLikeCount(reelId: reelId, increment: !isCurrentlyLiked)
    }
    
    // Update like count in Firestore
    private func updateReelLikeCount(reelId: String, increment: Bool) {
        let reelRef = db.collection("reels").document(reelId)
        
        // Use Firestore transactions to safely update the count
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let reelDocument = try transaction.getDocument(reelRef)
                
                // Get current like count
                guard let currentLikes = reelDocument.data()?["likes"] as? Int else {
                    return nil
                }
                
                // Calculate new like count
                let newLikes = increment ? currentLikes + 1 : currentLikes - 1
                
                // Update the document
                transaction.updateData(["likes": newLikes], forDocument: reelRef)
                
                return newLikes
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
        }) { (_, error) in
            if let error = error {
                print("Error updating reel like count: \(error.localizedDescription)")
                
                // Revert local state if update fails
                DispatchQueue.main.async { [weak self] in
                    guard let self = self, self.currentIndex < self.reels.count, 
                          let reelId = self.reels[self.currentIndex].id else { return }
                    
                    if increment {
                        self.likedReels.remove(reelId)
                        self.reels[self.currentIndex].likes -= 1
                    } else {
                        self.likedReels.insert(reelId)
                        self.reels[self.currentIndex].likes += 1
                    }
                }
            }
        }
    }
    
    // Check if a reel is liked
    func isReelLiked(reelId: String) -> Bool {
        return likedReels.contains(reelId)
    }
    
    // Add this method to the ReelsController class
    func reelAt(index: Int) -> Reel? {
        guard index >= 0, index < reels.count else { return nil }
        return reels[index]
    }
    
    // Add this method to the ReelsController class
    func togglePlayPause() {
        if isPlaying {
            pauseCurrentVideo()
        } else {
            playCurrentVideo()
        }
    }
    
    // Add a method to reset loading state in case of issues
    func resetLoadingState() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
        }
    }
    
    // Add a method to fetch thumbnail for a reel
    private func fetchThumbnailForReel(at index: Int) {
        guard index >= 0, index < reels.count else { return }
        let reel = reels[index]
        guard let reelId = reel.id else { return }
        
        // Try to get a thumbnail from Firebase Storage
        let thumbnailRef = storage.reference().child("thumbnails/\(reelId).jpg")
        
        thumbnailRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] (data, error) in
            guard let self = self else { return }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Store the thumbnail in the reel object or a separate cache
                    // This would require adding a thumbnailImage property to the Reel model
                    // self.reelThumbnails[reelId] = image
                }
            }
        }
    }
    
    // Add this method to download videos for new reels
    private func downloadVideosForNewReels(_ newReels: [Reel], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for (index, reel) in newReels.enumerated() {
            guard let reelId = reel.id else { continue }
            
            dispatchGroup.enter()
            
            // Create a reference to the video in Firebase Storage
            let videoRef = storage.reference().child("reels/\(reelId).mp4")
            
            // Get the download URL
            videoRef.downloadURL { [weak self] (url, error) in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                
                if let error = error {
                    print("Error getting download URL for new reel \(reelId): \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    print("Download URL is nil for new reel \(reelId)")
                    return
                }
                
                // Create a player for this reel and preload the video
                let player = AVPlayer()
                let playerItem = AVPlayerItem(url: downloadURL)
                
                // Set up custom loading options for better streaming
                playerItem.preferredForwardBufferDuration = 2.0
                
                // Replace the current item with the new one
                player.replaceCurrentItem(with: playerItem)
                
                // Set up looping for this player
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main) { _ in
                        player.seek(to: CMTime.zero)
                        player.play()
                    }
                
                // Store this player in our cache
                let globalIndex = self.reels.count + index
                self.playerCache[globalIndex] = player
                
//                print("Preloaded video for new reel at future index \(globalIndex)")
            }
        }
        
        // When all videos are downloaded, call the completion handler
        dispatchGroup.notify(queue: .main) {
            print("All videos for new reels have been preloaded")
            completion()
        }
    }
    
    // Update the checkAndFetchMoreReelsIfNeeded method
    private func checkAndFetchMoreReelsIfNeeded() {
        // If we're within 2 reels of the end, fetch more
        let threshold = 2
        if currentIndex >= reels.count - threshold {
            // Generate a new random threshold for the next fetch
            currentRandomThreshold = Int.random(in: 0...999999)
            fetchReelsWithRandomThreshold()
        }
    }
    
    // Add this method to completely randomize the reels order
    private func randomizeReelsOrder() {
        DispatchQueue.main.async {
            // Shuffle the entire reels array
            self.reels.shuffle()
            
            // Reset player assignments since indices have changed
            self.playerAssignments.removeAll()
            self.playerReelIndices = Array(repeating: -1, count: self.recycledPlayers.count)
            self.playerCache.removeAll()
            
            // Reset current index to 0
            self.currentIndex = 0
            
            // Reload the first few videos
            self.downloadVideosFromStorage()
        }
    }
}
