//
//  ChannelView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct ChannelView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var channel: Channel
    
    @State private var isChannelFollowed = false
    @State private var isUpgradeAccountSheetShowing: Bool = false
    @State private var isProAccountButNotRegisteredSheetShowing: Bool = false
    var body: some View {
        Group {
            if let id = channel.id, let title = channel.title, let numCourses = channel.numCourses, let numLectures = channel.numLectures, let channelDescription = channel.channelDescription {
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            HStack {
                                if let channelImage = courseController.channelThumbnails[id] {
                                    Image(uiImage: channelImage)
                                        .resizable()
                                        .frame(width: imageSize, height: imageSize)
                                } else {
                                    Image("stanford")
                                        .resizable()
                                        .frame(width: imageSize, height: imageSize)
                                }
                                
                                VStack {
                                    Text(title)
                                        .font(.system(size: titleFontSize, design: .serif))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack {
                                        Text("\(numCourses) Courses")
                                            .font(.system(size: subtitleFontSize))
                                            .opacity(0.6)
                                        
                                        Text("\(numLectures) Lectures")
                                            .font(.system(size: subtitleFontSize))
                                            .opacity(0.6)
                                        
                                        Spacer()
                                    }
                                }
                                
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
                                        } else {
                                            isProAccountButNotRegisteredSheetShowing = true
                                        }
                                    } else {
                                        self.isUpgradeAccountSheetShowing = true
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: isChannelFollowed ? "heart.fill" : "heart")
                                            .font(.system(size: buttonIconSize))
                                        
                                        Text(isChannelFollowed ? "Following" : "Follow")
                                            .font(.system(size: buttonTextSize, weight: .semibold))
                                    }
                                    .padding(.horizontal, buttonPadding)
                                    .padding(.vertical, buttonPadding * 0.5)
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
                                .sheet(isPresented: $isProAccountButNotRegisteredSheetShowing) {
                                    ProAccountButNotSignedInSheet(displaySheet: $isProAccountButNotRegisteredSheetShowing)
                                }
                            }
                            .cornerRadius(5)
                            
                            ExpandableText(text: channelDescription, maxLength: descriptionMaxLength)
                            
                            CoursesByChannel(channel: channel)
                                .padding(.top, 5)
                        }
                        .padding(.horizontal, horizontalPadding)
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
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image(systemName: "chevron.left")
//                    .bold()
//                Text("Back")
//            }
//        })
    }
    
    // Computed properties for responsive sizing
    private var imageSize: CGFloat {
        horizontalSizeClass == .regular ? 60 : 40
    }
    
    private var titleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 22 : 18
    }
    
    private var subtitleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 14 : 12
    }
    
    private var buttonIconSize: CGFloat {
        horizontalSizeClass == .regular ? 16 : 14
    }
    
    private var buttonTextSize: CGFloat {
        horizontalSizeClass == .regular ? 16 : 14
    }
    
    private var buttonPadding: CGFloat {
        horizontalSizeClass == .regular ? 20 : 16
    }
    
    private var horizontalPadding: CGFloat {
        horizontalSizeClass == .regular ? 40 : 20
    }
    
    private var descriptionMaxLength: Int {
        horizontalSizeClass == .regular ? 250 : 150
    }
}

//#Preview {
//    ChannelView()
//}
