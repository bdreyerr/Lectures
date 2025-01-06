//
//  Resource.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import FirebaseFirestore
import Foundation

struct Resource : Codable {
    // A resource can be any of the following - Notes, Homework (or Answers), Exam (or Answers)
    
    // identifier
    @DocumentID var id: String?
    
    var courseId: String?
    var lectureId: String?
    
    var title: String?
    
    var fileUrl: String?
    
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId
        case lectureId
        case title
        case fileUrl
        case createdAt
        case updatedAt
    }
}
