//
//  MyCoursesLoadingView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct MyCoursesLoadingView: View {
    var body: some View {
        VStack {
            // Course History
            HStack {
                SkeletonLoader(width: 250, height: 20)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                    
                    
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                }
                
            }
            .padding(.top, 2)
            .scrollDisabled(true)
            
            // Channels
            HStack {
                SkeletonLoader(width: 250, height: 20)
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
            
            // Communtiy favorites
            HStack {
                SkeletonLoader(width: 250, height: 20)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                    
                    
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                }
                
            }
            .padding(.top, 2)
            .scrollDisabled(true)
            
            // Popular lectures
            HStack {
                SkeletonLoader(width: 250, height: 20)
                    .padding(.top, 10)
                
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                    
                    
                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                }
                
            }
            .padding(.top, 2)
            .scrollDisabled(true)
        }
    }
}

#Preview {
    MyCoursesLoadingView()
}
