//
//  ChannelInfo.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import SwiftUI

struct ChannelInfo: View {
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var subscriptionController: SubscriptionController
    @EnvironmentObject var userController: UserController
    
    @State private var isChannelFollowed = false
    
    @State private var isUpgradeAccountSheetShowing: Bool = false
    @State private var isProAccountButNotRegisteredSheetShowing: Bool = false
    
    var channelId: String
    var body: some View {
        HStack {
            // channel image - nav link to channel view
            
            if let channel = courseController.cachedChannels[channelId] {
                NavigationLink(destination: ChannelView(channel: channel)) {
                    if let channelImage = courseController.channelThumbnails[channelId] {
                        Image(uiImage: channelImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        if let channelTitle = channel.title, let numCourses = channel.numCourses, let numLectures = channel.numLectures {
                            VStack {
                                Text(channelTitle)
                                    .font(.system(size: 14, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                HStack {
                                    Text("\(numCourses) Courses")
                                        .font(.system(size: 12))
                                        .opacity(0.6)
                                    
                                    Text("\(numLectures) Lectures")
                                        .font(.system(size: 12))
                                        .opacity(0.6)
                                    
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        HStack {
                            SkeletonLoader(width: 300, height: 40)
                            Spacer()
                        }
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    //                        self.shouldPopCourseFromStackOnDissapear = false
                    
                    // try to get the channel using course.channelId
                    if let channel = courseController.cachedChannels[channelId] {
                        courseController.focusChannel(channel)
                    }
                })
                .buttonStyle(PlainButtonStyle())
            }
            
            // Channel Follow Button
            Button(action: {
                // User can follow accounts if they are signed in, otherwise show sign in sheet
                if let user = userController.user, let userId = user.id {
                    if let rateLimit = rateLimiter.processWrite() {
                        print(rateLimit)
                        return
                    }
                    
                    userController.followChannel(userId: userId, channelId: channelId)
                    withAnimation(.spring()) {
                        isChannelFollowed.toggle()
                    }
                } else {
                    isProAccountButNotRegisteredSheetShowing = true
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isChannelFollowed ? "heart.fill" : "heart")
                        .font(.system(size: 14))
                    
                    Text(isChannelFollowed ? "Following" : "Follow")
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(isChannelFollowed ? .white : .primary)
                .background(
                    Capsule()
                        .fill(isChannelFollowed ? Color.red : Color.clear)
                        .overlay(
                            Capsule()
                                .strokeBorder(isChannelFollowed ? Color.red : Color.gray, lineWidth: 1)
                        )
                )
            }
            // Determine if the user has already followed this channel or not, if they have, change the button view
            .onAppear {
                if let user = userController.user, let followedChannelIds = user.followedChannelIds {
                    if followedChannelIds.contains(channelId) {
                        self.isChannelFollowed = true
                    }
                }
            }
            .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
            }
            .sheet(isPresented: $isProAccountButNotRegisteredSheetShowing) {
                ProAccountButNotSignedInSheet(displaySheet: $isProAccountButNotRegisteredSheetShowing)
            }
            
        }
        .cornerRadius(5)
    }
}

//#Preview {
//    ChannelInfo()
//}
