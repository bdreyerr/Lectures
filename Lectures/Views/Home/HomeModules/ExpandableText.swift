//
//  ExpandableText.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import SwiftUI

struct ExpandableText: View {
    let text: String
    let maxLength: Int
    @State private var isExpanded: Bool = false
    
    private var truncatedText: String {
        if text.count <= maxLength || isExpanded {
            return text
        }
        return String(text.prefix(maxLength)) + "..."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(truncatedText)
                .font(.system(size: 13, design: .serif))
                .opacity(0.8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if text.count > maxLength {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Show Less" : "Show More")
                        .font(.system(size: 12))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    ExpandableText(text: "Professor Minsky captivated the audience at MIT's Stata Center with a two-hour exploration of how mental agents cooperate and compete within human consciousness, using playful analogies ranging from jazz improvisation to children building with blocks. He particularly emphasized how our perception of having a unified mind is an illusion, demonstrating through interactive thought experiments how different parts of our cognitive processes work independently yet create what feels like a seamless mental experience.", maxLength: 100)
}
