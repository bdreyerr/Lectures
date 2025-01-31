//
//  Lecture.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/1/25.
//

import FirebaseFirestore
import Foundation

struct Lecture : Codable, Identifiable, Hashable {
    // identifier
    @DocumentID var id: String?
    
    // the parent course this lecture belongs to
    var courseId: String?
    // parent channel
    var channelId: String?
    
    // course metadata
    var lectureTitle: String?
    var courseTitle: String?
    var professorName: String?
    var channelName: String?
    var lectureDescription: String?
    var lectureNumberInCourse: Int?
    var viewsOnYouTube: Int?
    var datePostedonYoutube: String?
    var numLikesInApp: Int?
    
    // Resources
    var notesResourceId: String?
    var homeworkResourceId: String?
    var homeworkAnswersResourceId: String?
    
    var youtubeVideoUrl: String?
    
    var searchTerms: [String]?
    
    var thumbnailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId
        case channelId
        case lectureTitle
        case courseTitle
        case professorName
        case channelName
        case lectureDescription
        case lectureNumberInCourse
        case viewsOnYouTube
        case datePostedonYoutube
        case numLikesInApp
        case notesResourceId
        case homeworkResourceId
        case homeworkAnswersResourceId
        case youtubeVideoUrl
        case searchTerms
        case thumbnailUrl
    }
}
