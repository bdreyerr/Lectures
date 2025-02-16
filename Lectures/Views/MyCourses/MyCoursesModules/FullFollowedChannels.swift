//
//  FullFollowedChannels.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/11/25.
//

import SwiftUI

struct FullFollowedChannels: View {
    @EnvironmentObject var myCourseController: MyCourseController
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var userController: UserController
    
    @State private var followedChannelIds: [String] = []
    
    var body: some View {
        VStack {
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
            
            ScrollView() {
                ForEach(followedChannelIds, id: \.self) { channelId in
                    HStack {
                        if let channel = courseController.cachedChannels[channelId] {
                            NavigationLink(destination: ChannelView(channel: channel)) {
                                ChannelCard(channel: channel)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(TapGesture().onEnded {
                                courseController.focusChannel(channel)
                            })
                        }
                        
                        Spacer()
                    }
                }
            }
            
            if myCourseController.currentChannelOffset < followedChannelIds.count {
                
                FetchButton(isMore: true) {
                    myCourseController.loadMoreFollowedChannels(channelIds: followedChannelIds, courseController: courseController)
                }
                .padding(.top, 6)
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
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
}

#Preview {
    FullFollowedChannels()
}
