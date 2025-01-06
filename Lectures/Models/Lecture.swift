//
//  Lecture.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/1/25.
//

import FirebaseFirestore
import Foundation

struct Lecture : Codable, Identifiable {
    // identifier
    @DocumentID var id: String?
    
    // the parent course this lecture belongs to
    var courseId: String?
    // parent channel
    var channelId: String?
    
    // course metadata
    var lectureTitle: String?
    var professorName: String?
    var channelName: String?
    var lectureDescription: String?
    var lectureNumberInCourse: Int?
    var viewsOnYouTube: String?
    var datePostedonYoutube: String?
    var numLikesInApp: Int?
    
    // Resources
    var hasNotes: Bool?
    var notesResourceId: String?
    
    var hasHomework: Bool?
    var homeworkResourceId: String?
    
    var hasHomeworkAnswers: Bool?
    var homeworkAnswersResourceId: String?
    
    // thumbail and YouTube Info
    var thumbnailUrl: String?
    var youtubeVideoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId
        case channelId
        case lectureTitle
        case professorName
        case channelName
        case lectureDescription
        case lectureNumberInCourse
        case viewsOnYouTube
        case datePostedonYoutube
        case numLikesInApp
        case hasNotes
        case notesResourceId
        case hasHomework
        case homeworkResourceId
        case hasHomeworkAnswers
        case homeworkAnswersResourceId
        case thumbnailUrl
        case youtubeVideoUrl
    }
}
