//
//  RateLimiter.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/23/25.
//

import Foundation
import SwiftUI


class RateLimiter : ObservableObject {
    @Published var numActionsInLastMinute: Int = 0
    @Published var firstActionDate: Date?
    
    // Count the number of times the user breaches the rate limit
    @Published var numberBreach: Int = 0
    
    @Published var shouldRateLimitPopupShow: Bool = false
    
    
    // Rate limiting - limits firestore writes and blocks spamming in a singular user session. app is still prone to attacks in multiple app sessions (closing and re-opening)
    // Limits users to 5 writes in one minute
    func processWrite() -> String? {
        // Cases:
        // 1. This is the first action - first action date doesn't exist
        // Set first action to Date()
        // set num actions = 1
        // 2. First action exists && currentAction is less than one minute from first action
        // Allow action if numActions < 5
        // set num actions += 1
        // Block action if numActions >= 5
        // 3. First action exists - current action is greater than one minute from first action
        // allow action
        // set first action date to Date()
        // set num action = 1
        
        if let firstActionDate = self.firstActionDate {
            
            // Get firstActionDate + 60 seconds
            let oneMinFromFirst = Calendar.current.date(byAdding: .second, value: 60, to: firstActionDate)
            
            if let oneMinFromFirst {
                if Date() < oneMinFromFirst {
                    if self.numActionsInLastMinute < 5 {
                        self.numActionsInLastMinute += 1
                    } else {
                        numberBreach += 1
                        withAnimation(.spring()) {
                            self.shouldRateLimitPopupShow = true
                        }
                        return "Too many actions in one minute"
                    }
                } else {
                    self.firstActionDate = Date()
                    self.numActionsInLastMinute = 1
                }
            }
        } else {
            self.firstActionDate = Date()
            self.numActionsInLastMinute = 1
        }
        
        return nil
    }
}

