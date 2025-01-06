//
//  Channel.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import FirebaseFirestore
import Foundation

struct Channel : Codable, Identifiable {
    // identifier
    @DocumentID var id: String?
    
    // title
    var title: String?
    
    // channel description
    var channelDescription: String?
    
    // courses
    var courseIds: [String]?
    
    // stats
    var numCourses: Int?
    var numLectures: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case channelDescription
        case courseIds
        case numCourses
        case numLectures
    }
    
    // MIT, Stanford, Yale, Harvard, Oxford
}
