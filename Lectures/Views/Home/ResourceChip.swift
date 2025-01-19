//
//  ResourceChip.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import SwiftUI

struct ResourceChip: View {
    var resource: Resource
    
    @Binding var shouldPopFromStack: Bool
    var body: some View {
        
        
        
        HStack {
            
            NavigationLink(destination: ResourceView(resource: resource)) {
                // Main content container
                HStack(spacing: 5) {
                    Image(systemName: "doc.circle")
                        .font(.system(size: 18, design: .serif))
                    
                    Text(resource.title?.prefix(50) ?? "")
                        .font(.system(size: 12, design: .serif))
                        .underline(color: .blue)
                        .lineLimit(1)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                // Background and border styling
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(TapGesture().onEnded { _ in
                shouldPopFromStack = false
            })
            
            Spacer()
        }
    }
}

//#Preview {
//    ResourceChip(resource: Resource(title: "Exam - 1. Introduction to 'The Society of Mind'"), shouldPopFromStack: .constant(false))
//}
