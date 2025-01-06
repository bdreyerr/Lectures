//
//  ChannelView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct ChannelView: View {
    @EnvironmentObject var homeController: HomeController
    
    @State private var isChannelFollowed = false
    var body: some View {
        if let channel = homeController.focusedChannel {
            VStack {
                // Course Cover Image?
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            // channel image not a nav link
                            if let channelImage = homeController.channelThumbnails[channel.id!] {
                                Image(uiImage: channelImage)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: 40, height: 40)
                            } else {
                                Image("stanford")
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .frame(width: 40, height: 40)
                            }
                            
                            // channel title
                            VStack {
                                Text(channel.title ?? "")
                                    .font(.system(size: 18, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // channel stats
                                HStack {
                                    Text("\(channel.numCourses!) Courses")
                                        .font(.system(size: 12, design: .serif))
                                        .opacity(0.6)
                                    
                                    Text("\(channel.numLectures!) Lectures")
                                        .font(.system(size: 12, design: .serif))
                                        .opacity(0.6)
                                    
                                    Spacer()
                                }
                            }
                            
                            // follow button
                            Button(action: {
                                withAnimation(.spring()) {
                                    isChannelFollowed.toggle()
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
                        }
                        
                        
                        
                        ExpandableText(text: channel.channelDescription!, maxLength: 150)
                        
                        
                        // we have access to our courseId list under this channel, and they should have been all added to the cache when the chanell got focused
                        
                        CoursesByChannel()
                            .padding(.top, 5)
                    }
                    .padding(.horizontal, 20)
                }
            }
        } else {
            Text("no focused channel")
        }
    }
}

#Preview {
    ChannelView()
}
