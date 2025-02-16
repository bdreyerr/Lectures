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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var channel: Channel
    
    var body: some View {
        if let id = channel.id, let title = channel.title, let numCourses = channel.numCourses, let numLectures = channel.numLectures {
            HStack {
                if let image = courseController.channelThumbnails[id] {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                        .aspectRatio(contentMode: .fill)
                } else {
                    // default image when not loaded
                    SkeletonLoader(width: imageSize, height: imageSize)
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
                .frame(maxWidth: cardWidth)
            }
            .cornerRadius(5)
        }
    }
    
    // Computed properties for responsive sizing
    private var imageSize: CGFloat {
        horizontalSizeClass == .regular ? 60 : 40
    }
    
    private var cardWidth: CGFloat {
        horizontalSizeClass == .regular ? 240 : 180
    }
    
    private var titleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 16 : 14
    }
    
    private var subtitleFontSize: CGFloat {
        horizontalSizeClass == .regular ? 14 : 12
    }
}

#Preview {
    ChannelCard(channel: Channel())
        .environmentObject(HomeController())
}
