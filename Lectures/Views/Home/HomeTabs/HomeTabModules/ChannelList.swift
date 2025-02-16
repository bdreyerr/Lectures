//
//  ChannelList.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/15/25.
//

import SwiftUI

struct ChannelList: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var tabName: String
    
    var body: some View {
        if let channelList = homeController.leadingChannelsPerTab[tabName] {
            VStack(alignment: .leading) {
                HStack {
                    
                    Image(systemName: "graduationcap")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Text("Leading Universities")
                        .font(.system(size: 10))
                        .opacity(0.8)
                    
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        let groupedUniversities = stride(from: 0, to: channelList.count, by: 2).map { index in
                            Array(channelList[index..<min(index + 2, channelList.count)])
                        }
                        
                        ForEach(groupedUniversities.indices, id: \.self) { groupIndex in
                            let group = groupedUniversities[groupIndex]
                            VStack(spacing: 16) {
                                ForEach(group, id: \.id) { channel in
                                    if homeController.isLeadingChannelsLoading {
                                        SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                                    } else {
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
                            .padding(.trailing, 10)
                        }
                    }
                }
            }
            .frame(maxHeight: 220)
        }
    }
}

//#Preview {
//    ChannelList()
//}
