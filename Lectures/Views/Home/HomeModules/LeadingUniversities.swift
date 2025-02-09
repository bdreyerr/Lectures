//
//  LeadingUniversities.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct LeadingUniversities: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
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
                    let groupedUniversities = stride(from: 0, to: homeController.leadingUniversities.count, by: 2).map { index in
                        Array(homeController.leadingUniversities[index..<min(index + 2, homeController.leadingUniversities.count)])
                    }
                    
                    ForEach(groupedUniversities.indices, id: \.self) { groupIndex in
                        let group = groupedUniversities[groupIndex]
                        VStack(spacing: 16) {
                            ForEach(group, id: \.id) { channel in
                                if homeController.isUniversityLoading {
                                    SkeletonLoader(width: UIScreen.main.bounds.width * 0.6, height: 150)
                                } else {
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
                        .padding(.trailing, 10)
                    }
                }
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    LeadingUniversities()
        .environmentObject(HomeController())
}
