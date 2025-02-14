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
    @EnvironmentObject var myCourseController: MyCourseController
    
    @State private var followedChannelIds: [String] = []
    
    var body: some View {
        Group {
            // Followed Channels
            HStack {
                Image(systemName: "graduationcap")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Text("Channels You Follow")
                    .font(.system(size: 10))
                    .opacity(0.8)
                
                Spacer()
            }
            .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(followedChannelIds, id: \.self) { channelId in
                        if let channel = courseController.cachedChannels[channelId] {
                            NavigationLink(destination: ChannelView(channel: channel)) {
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
            HStack {
                NavigationLink(destination: FullFollowedChannels()) {
                    Text("View All")
                        .font(.system(size: 10))
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            .padding(.top, 1)
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
