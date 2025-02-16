//
//  RateLimiter.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/23/25.
//

import Foundation
import SwiftUI


class RateLimiter : ObservableObject {
    @AppStorage("numActionsInLastMinute") private var numActionsInLastMinute: Int = 0
    @AppStorage("firstActionDateTimeInterval") private var firstActionDateTimeInterval: Double? {
        didSet {
            firstActionDate = firstActionDateTimeInterval.map { Date(timeIntervalSince1970: $0) }
        }
    }
    private var firstActionDate: Date?
    
    @AppStorage("numberBreach") private var numberBreach: Int = 0
    @AppStorage("lastBreachTimeInterval") private var lastBreachTimeInterval: Double?
    @Published var shouldRateLimitPopupShow: Bool = false
    
    
    init() {
        self.firstActionDate = firstActionDateTimeInterval.map { Date(timeIntervalSince1970: $0) }
        
        if let lastBreachTime = lastBreachTimeInterval {
            let lastBreachDate = Date(timeIntervalSince1970: lastBreachTime)
            let timeoutDuration: TimeInterval
            
            switch numberBreach {
            case 0, 1: timeoutDuration = 60
            case 2: timeoutDuration = 300
            case 3: timeoutDuration = 600
            default: timeoutDuration = 300
            }
            
            if Date() < lastBreachDate.addingTimeInterval(timeoutDuration) {
                shouldRateLimitPopupShow = true
            }
        }
    }
    
    // Rate limiting - limits firestore writes and blocks spamming in a singular user session. app is still prone to attacks in multiple app sessions (closing and re-opening)
    // Limits users to 10 writes in one minute
    func processWrite() -> String? {
        if shouldRateLimitPopupShow {
            return "Too many actions in one minute"
        }
        
        if let firstActionDate = self.firstActionDate {
            
            // Get firstActionDate + 60 seconds
            let oneMinFromFirst = Calendar.current.date(byAdding: .second, value: 60, to: firstActionDate)
            
            if let oneMinFromFirst {
                if Date() < oneMinFromFirst {
                    if self.numActionsInLastMinute < 10 {
                        self.numActionsInLastMinute += 1
                    } else {
                        withAnimation(.spring()) {
                            self.shouldRateLimitPopupShow = true
                        }
                        self.numberBreach += 1
                        self.lastBreachTimeInterval = Date().timeIntervalSince1970
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

