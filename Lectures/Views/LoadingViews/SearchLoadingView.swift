//
//  SearchLoadingView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct SearchLoadingView: View {
    var body: some View {
        VStack {
            // Channels
            HStack {
                SkeletonLoader(width: 250, height: 10)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    VStack {
                        SkeletonLoader(width: 200, height: 50)
                        
                        
                        SkeletonLoader(width: 200, height: 50)
                    }
                    
                    VStack {
                        SkeletonLoader(width: 200, height: 50)
                        
                        
                        SkeletonLoader(width: 200, height: 50)
                    }
                }
                
            }
            .padding(.top, 2)
            .scrollDisabled(true)
        }
        
        // Courses
        HStack {
            SkeletonLoader(width: 250, height: 10)
                .padding(.top, 10)
            
            Spacer()
        }
        
        ScrollView(.horizontal) {
            VStack {
                
                SkeletonLoader(width: 120, height: 67.5)
                
                
                SkeletonLoader(width: 120, height: 67.5)
            }
            
        }
        .padding(.top, 2)
        .scrollDisabled(true)
        
        // Lectures
        HStack {
            SkeletonLoader(width: 250, height: 10)
                .padding(.top, 10)
            
            Spacer()
        }
        
        ScrollView(.horizontal) {
            VStack {
                
                SkeletonLoader(width: 120, height: 67.5)
                
                
                SkeletonLoader(width: 120, height: 67.5)
            }
            
        }
        .padding(.top, 2)
        .scrollDisabled(true)
    }
}

#Preview {
    SearchLoadingView()
}
