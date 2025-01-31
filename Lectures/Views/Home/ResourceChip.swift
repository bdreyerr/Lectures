//
//  ResourceChip.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import SwiftUI

struct ResourceChip: View {
    var resource: Resource
    
    var exampleText: String = """
# Header 1\n## Header 2\n### Header 3
"""

    
    @Binding var shouldPopFromStack: Bool
    var body: some View {
        HStack {
            
//            NavigationLink(destination: ResourceView(resource: resource)) {
            NavigationLink(destination: ResourceNativeView(resourceTitle: resource.title ?? "", resourceContent: resource.content ?? "")) {
                // Main content container
                HStack(spacing: 5) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(Color.blue.opacity(0.8))
                    
                    Text(resource.title?.prefix(50) ?? "")
                        .font(.system(size: 12, design: .serif))
                        .opacity(0.9)
                        .lineLimit(1)
                        .underline(color: .gray)
                }
//                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                // Background and border styling
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .strokeBorder(
//                            LinearGradient(
//                                colors: [.red, .orange, .yellow, .green, .blue, .purple],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            ).opacity(0.6),
//                            lineWidth: 1
//                        )
//                )
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
