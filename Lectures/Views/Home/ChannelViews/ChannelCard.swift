//
//  ChannelCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import SwiftUI

struct ChannelCard: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var channel: Channel
    
    var body: some View {
        HStack {
            if let image = courseController.channelThumbnails[channel.id!] {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fill)
            } else {
                // default image when not loaded
                SkeletonLoader(width: 50, height: 50)
            }
            
            VStack {
                Text(channel.title!)
                    .font(.system(size: 14, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("\(channel.numCourses!) Courses")
                        .font(.system(size: 12))
//                                                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                    
                    Text("\(channel.numLectures!) Lectures")
                        .font(.system(size: 12))
//                                                        .font(.system(size: 12, design: .serif))
                        .opacity(0.6)
                    
                    Spacer()
                }
            }
        }
        .cornerRadius(5)
    }
}

#Preview {
    ChannelCard(channel: Channel())
        .environmentObject(HomeController())
}
