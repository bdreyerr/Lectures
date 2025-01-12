//
//  LoaderPreview.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/7/25.
//

import SwiftUI

struct LoaderPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header skeleton
            SkeletonLoader(width: 300, height: 40)
            
            // Text line skeletons
            ForEach(0..<3) { _ in
                SkeletonLoader(width: 250, height: 20)
            }
            
            // Image placeholder skeleton
            SkeletonLoader(width: 200, height: 200)
        }
        .padding()
    }
}

#Preview {
    LoaderPreview()
}
