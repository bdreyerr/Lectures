//
//  ResourceController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import Foundation

class ResourceController : ObservableObject {
    // Path : PDF URL
    @Published var cachedUrls: [String : URL] = [:]
}
