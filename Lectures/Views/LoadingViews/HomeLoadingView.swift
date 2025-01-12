//
//  HomeLoadingView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/8/25.
//

import SwiftUI

struct HomeLoadingView: View {
    var body: some View {
        VStack {
            // Categories
            HStack {
                SkeletonLoader(width: 250, height: 20)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    SkeletonLoader(width: 400 * 0.6, height: 150)
                    
                    
                    SkeletonLoader(width: 400 * 0.6, height: 150)
                }
                
            }
            .padding(.top, 10)
            .scrollDisabled(true)
            
            HStack {
                SkeletonLoader(width: 250, height: 20)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    SkeletonLoader(width: 400 * 0.6, height: 150)
                    
                    
                    SkeletonLoader(width: 400 * 0.6, height: 150)
                }
                
            }
            .padding(.top, 10)
            .scrollDisabled(true)
            
            HStack {
                SkeletonLoader(width: 250, height: 20)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    SkeletonLoader(width: 400 * 0.6, height: 150)
                    
                    
                    SkeletonLoader(width: 400 * 0.6, height: 150)
                }
            }
            .padding(.top, 10)
            .scrollDisabled(true)
        }
    }
}

#Preview {
    HomeLoadingView()
}
