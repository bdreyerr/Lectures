//
//  RateLimitPopUp.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/23/25.
//

import SwiftUI

struct RateLimitPopUp: View {
    
    @AppStorage("numberBreach") private var numberBreach: Int = 0
    
    @EnvironmentObject var rateLimiter: RateLimiter
    
    
    @State private var timeRemaining: Int = 60
    @State private var timer: Timer?
    
    func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            guard rateLimiter.shouldRateLimitPopupShow else {
                stopTimer()
                return
            }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                rateLimiter.shouldRateLimitPopupShow = false
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        if timeRemaining <= 0 {
            numberBreach = 0  // Reset the breach counter when timeout completes
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                // TODO: should or should not let users close out of this?
//                HStack {
//                    Spacer()
//                    
//                    Button(action: {
//                        rateLimiter.shouldRateLimitPopupShow = false
//                    }) {
//                        Text("Close")
//                            .foregroundStyle(Color.red)
//                            .font(.caption)
//                    }
//                }
                
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.red)
                
                
                Text("Too Many Actions")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Please wait \(timeRemaining) seconds before continuing.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Text("Actions are temporarily disabled")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: 300)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 10)
        }
        .onAppear {
            switch numberBreach {
            case 0: timeRemaining = 60
            case 1: timeRemaining = 60
            case 2: timeRemaining = 300
            case 3: timeRemaining = 600
            case 4...: timeRemaining = 300
            default: timeRemaining = 300
            }
            startCountdown()
        }
        .onDisappear {
            stopTimer()
        }
    }
}

#Preview {
    RateLimitPopUp()
}
