//
//  FetchButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/14/25.
//

import SwiftUI

struct FetchButton: View {
    let isMore: Bool  // determines if button shows "Fetch More" or "Fetch Previous"
    let action: () -> Void  // closure for button action
    
    var body: some View {
        Button(action: action) {
            Text(isMore ? "Fetch More" : "Fetch Previous")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(6)
        }
    }
}

// #Preview {
//     HStack {
//         FetchButton(isMore: true, action: {})
//         FetchButton(isMore: false, action: {})
//     }
// }
