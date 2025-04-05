//
//  Reel.swift
//  Lectures
//
//  Created by Ben Dreyer on 3/9/25.
//

import FirebaseFirestore
import Foundation

struct Reel: Codable, Identifiable {
    @DocumentID var id: String?
    // Linked attributes
    var lectureId: String?
    var lectureName: String?
    var courseId: String?
    var courseName: String?
    var channelId: String?
    var channelName: String?
    var youtubeUrl: String?
    
    // Added fields for reels functionality
    var videoURL: String
    var likes: Int
    var comments: Int
    var shares: Int
    
    // Random number so we can fetch random videos in the feed.
    var randomNumber: Int?
    
    // For local testing with sample videos
    static let samples = [
        Reel(videoURL: "sample1", likes: 1200, comments: 45, shares: 67),
        Reel(videoURL: "sample2", likes: 890, comments: 32, shares: 41),
        Reel(videoURL: "sample3", likes: 750, comments: 28, shares: 35)
    ]
    
    // Custom Codable implementation to handle potential missing fields
    enum CodingKeys: String, CodingKey {
        case id, lectureId, lectureName, courseId, courseName, channelId, channelName, youtubeUrl, randomNumber
        case videoURL, likes, comments, shares
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields
        videoURL = try container.decodeIfPresent(String.self, forKey: .videoURL) ?? ""
        
        // Optional fields with defaults
        likes = try container.decodeIfPresent(Int.self, forKey: .likes) ?? 0
        comments = try container.decodeIfPresent(Int.self, forKey: .comments) ?? 0
        shares = try container.decodeIfPresent(Int.self, forKey: .shares) ?? 0
        
        // Other optional fields
        id = try container.decodeIfPresent(String.self, forKey: .id)
        lectureId = try container.decodeIfPresent(String.self, forKey: .lectureId)
        lectureName = try container.decodeIfPresent(String.self, forKey: .lectureName)
        courseId = try container.decodeIfPresent(String.self, forKey: .courseId)
        courseName = try container.decodeIfPresent(String.self, forKey: .courseName)
        channelId = try container.decodeIfPresent(String.self, forKey: .channelId)
        channelName = try container.decodeIfPresent(String.self, forKey: .channelName)
        youtubeUrl = try container.decodeIfPresent(String.self, forKey: .youtubeUrl)
        randomNumber = try container.decodeIfPresent(Int.self, forKey: .randomNumber)
    }
    
    // Constructor for sample data
    init(videoURL: String, likes: Int, comments: Int, shares: Int) {
        self.videoURL = videoURL
        self.likes = likes
        self.comments = comments
        self.shares = shares
    }
}
