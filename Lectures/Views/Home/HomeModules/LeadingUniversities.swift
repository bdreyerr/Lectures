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
                Text("Leading Universities")
                    .font(.system(size: 14, design: .serif))
                    .bold()
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeController.leadingUniversities, id: \.id) { channel in
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
            }
        }
        .frame(maxHeight: 220)
    }
}

#Preview {
    LeadingUniversities()
        .environmentObject(HomeController())
}
