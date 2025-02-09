//
//  Course.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/1/25.
//

import FirebaseFirestore
import Foundation

struct Course : Codable, Identifiable, Hashable {
    // Identifiers
    @DocumentID var id: String?
    
    // Channel Link
    var channelId: String?
    
    // Course Metadata
    var courseTitle: String?
    var courseDescription: String?
    var professorName: String?
    var numLecturesInCourse: Int?
    var watchTimeInHrs: Int?
    var aggregateViews: Int?
    var categories: [String]?
    var numLikesInApp: Int?
    
    // Resource Information
    var examResourceId: String?
    var examAnswersResourceId: String?
    
    // Lectures inside of the course, using their ID
    var lectureIds: [String]?
    
    // Terms used to search for this course (title, channel, categories, etc..)
    var searchTerms: [String]?
    
    // link to thumbnail on the web (not in storage, we'll download it from this link)
    var thumbnailUrl: String?
    
    var numViews: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case channelId
        case courseTitle
        case courseDescription
        case professorName
        case numLecturesInCourse
        case watchTimeInHrs
        case aggregateViews
        case categories
        case numLikesInApp
//        case hasExam
//        case hasExamAnswers
        case examResourceId
        case examAnswersResourceId
        case lectureIds
        case searchTerms
        case thumbnailUrl
        case numViews
    }
}
