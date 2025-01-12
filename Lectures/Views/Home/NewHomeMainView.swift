//
//  NewHomeMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/9/25.
//

import SwiftUI

struct NewHomeMainView: View {
//    @Environment(\.colorScheme) var colorScheme
//    @EnvironmentObject var homeController: HomeController
//    
//    // YouTube Player Controller
//    // we initalize it here because we want to change source url when we foucs a new lecture, which happens in this view sometimes. sometimes also happens in lecture view, but this is a parent of lecture view
//    // Youtube player
//    @StateObject var youTubePlayerController = YouTubePlayerController()
//    
//    @State var userHasPreviouslyWatchedLectures: Bool = true
    var body: some View {
        NavigationView {
            VStack {
                TopBrandView()
                
                ScrollView (showsIndicators: false) {
                    
                }
            }
        }
    }
}

#Preview {
    NewHomeMainView()
//        .environmentObject(youTubePlayerController)
}
