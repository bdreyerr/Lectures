//
//  FullChannelSearchResults.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct FullChannelSearchResults: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var searchController: SearchController
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Image(systemName: "person")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Text("Channels")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    Spacer()
                }
                .padding(.top, 10)
                
                ForEach(searchController.searchResultChannels, id: \.id) { channel in
                    NavigationLink(destination: ChannelView(channel: channel)) {
                        ChannelCard(channel: channel)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        courseController.focusChannel(channel)
                    })
                }
                
                if !searchController.noChannelsLeftToLoad {
                    
                    FetchButton(isMore: true) {
                        searchController.getMoreChannels(courseController: courseController)
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 80)
                    
                }
                
                Spacer()
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    FullChannelSearchResults()
}
