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
    
    
    // 0: Notes
    // 1: Homework
    // 2: Homework Answers
    // 3: Exam
    // 4: Exam Answers
    var resourceType: Int?
    
    var title: String?
    
    var content: String?
    
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId
        case lectureId
        case resourceType
        case title
        case content
        case createdAt
        case updatedAt
    }
}
