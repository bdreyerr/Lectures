//
//  ChannelView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct ChannelView: View {
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @State private var isChannelFollowed = false
    @State private var isUpgradeAccountSheetShowing: Bool = false
    var body: some View {
        if let channel = courseController.focusedChannel, let id = channel.id, let title = channel.title, let numCourses = channel.numCourses, let numLectures = channel.numLectures, let channelDescription = channel.channelDescription {
            VStack {
                // Course Cover Image?
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            // channel image not a nav link
                            if let channelImage = courseController.channelThumbnails[id] {
                                Image(uiImage: channelImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            } else {
                                Image("stanford")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            
                            // channel title
                            VStack {
                                Text(title)
                                    .font(.system(size: 18, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // channel stats
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
                            
                            // follow button
                            Button(action: {
                                // if the user isn't a PRO member, they can't follow accounts
                                if subscriptionController.isPro {
                                    if let user = userController.user, let userId = user.id {
                                        if let rateLimit = rateLimiter.processWrite() {
                                            print(rateLimit)
                                            return
                                        }
                                        
                                        userController.followChannel(userId: userId, channelId: id)
                                        withAnimation(.spring()) {
                                            isChannelFollowed.toggle()
                                        }
                                    }
                                    return
                                }
                                
                                self.isUpgradeAccountSheetShowing = true
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
                        }
                        .cornerRadius(5)
                        
                        
                        
                        ExpandableText(text: channelDescription, maxLength: 150)
                        
                        
                        // we have access to our courseId list under this channel, and they should have been all added to the cache when the chanell got focused
                        
                        CoursesByChannel()
                            .padding(.top, 5)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .sheet(isPresented: $isUpgradeAccountSheetShowing) {
                UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
            }
            .onAppear {
                // check if the user follows the course's channel and set the button accordingly
                if let user = userController.user, let followedChannelIds = user.followedChannelIds {
                    if followedChannelIds.contains(id) {
                        self.isChannelFollowed = true
                    }
                }
            }
        } else {
            ErrorLoadingView()
        }
    }
}

#Preview {
    ChannelView()
}
