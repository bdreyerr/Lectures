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
    var channelId: String?
    
    // lecture progress - used fpr progress bar
    var lectureNumberInCourse: Int?
    var numLecturesInCourse: Int?
    
    // timestamp course was watched last
    var courseLastWatched: Timestamp?
    
    var isCourseCompleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case courseId
        case lectureId
        case channelId
        case lectureNumberInCourse
        case numLecturesInCourse
        case courseLastWatched
        case isCourseCompleted
    }
    
    // Add this initializer
    init(userId: String?,
         courseId: String?,
         lectureId: String?,
         channelId: String?,
         lectureNumberInCourse: Int?,
         numLecturesInCourse: Int?,
         courseLastWatched: Timestamp?,
         isCourseCompleted: Bool?,
         id: String? = nil) {  // id is optional with default value
        
        self.userId = userId
        self.courseId = courseId
        self.lectureId = lectureId
        self.channelId = channelId
        self.lectureNumberInCourse = lectureNumberInCourse
        self.numLecturesInCourse = numLecturesInCourse
        self.courseLastWatched = courseLastWatched
        self.isCourseCompleted = isCourseCompleted
        self.id = id
    }
}
