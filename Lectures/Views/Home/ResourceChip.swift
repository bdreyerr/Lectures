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
        
        NavigationLink(destination: ResourceView(resource: resource)) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.clear)
                .frame(minWidth: 200)
                .frame(height: 30)
                .overlay {
                    HStack {
                        Image(systemName: "doc.circle")
                            .font(.system(size: 18, design: .serif))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text(resource.title!.prefix(50))
                            .font(.system(size: 12, design: .serif))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.black, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(TapGesture().onEnded { _ in
            shouldPopFromStack = false
        })
    }
}

//#Preview {
//    ResourceChip(resource: Resource(title: "Exam - 1. Introduction to 'The Society of Mind'"), shouldPopFromStack: $false)
//}
