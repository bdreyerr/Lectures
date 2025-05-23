//
//  ApplicationUtility.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import Foundation
import SwiftUI
import UIKit

// This is needed for Google Sign in SDK.
final class ApplicationUtility {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}
