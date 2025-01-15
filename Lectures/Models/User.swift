//
//  User.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/30/24.
//

import FirebaseFirestore
import Foundation

struct User : Codable {
    @DocumentID var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    
    // 0 = Free, 1 = Pro
    var accountType: Int?
    
    var isAdmin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case email
        case accountType
        case isAdmin
    }
}
