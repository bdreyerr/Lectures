//
//  FollowedChannels.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import SwiftUI

struct FollowedChannels: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    
    @State private var followedChannelIds: [String] = []
    
    var body: some View {
        Group {
            // Followed Channels
            HStack {
                Text("Channels you Follow")
                    .font(.system(size: 13, design: .serif))
                    .bold()
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(followedChannelIds, id: \.self) { channelId in
                        if let channel = courseController.cachedChannels[channelId] {
                            NavigationLink(destination: ChannelView()) {
                                ChannelCard(channel: channel)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                courseController.focusChannel(channel)
                            })
                        }
                    }
                }
            }
        }
        .onAppear {
            if let user = userController.user {
                // Update the state variable when `user` changes
                DispatchQueue.main.async {
                    followedChannelIds = user.followedChannelIds ?? []
                }
            }
        }
    }
}

#Preview {
    FollowedChannels()
}
