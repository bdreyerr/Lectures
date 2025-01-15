//
//  WatchHistory.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/15/25.
//

import FirebaseFirestore
import Foundation


struct WatchHistory : Codable {
    @DocumentID var id: String?
    var userId: String?
    var courseId: String?
    var lectureId: String?
    
    // lecture progress
    var lectureNumberInCourse: Int?
    var numLecturesInCourse: Int?
    
    // watch time of lecture
    var watchedDurationOfLecture: Int?
    
    // timestamp course was watched last
    var courseLastWatched: Timestamp?
    
    var isCourseCompleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case courseId
        case lectureId
        case lectureNumberInCourse
        case numLecturesInCourse
        case watchedDurationOfLecture
        case courseLastWatched
        case isCourseCompleted
    }
}
