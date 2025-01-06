//
//  LeadingUniversities.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct LeadingUniversities: View {
    @EnvironmentObject var homeController: HomeController
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Leading Universities")
                    .font(.system(size: 20, design: .serif))
                    .bold()
                
                Spacer()
                
//                NavigationLink(destination: CommunityFavoritesFullList()) {
//                    Text("View All")
//                        .font(.system(size: 12, design: .serif))
//                        .opacity(0.6)
//                }
//                .buttonStyle(PlainButtonStyle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(homeController.leadingUniversities, id: \.id) { channel in
                        NavigationLink(destination: ChannelView()) {
                            ChannelCard(channel: channel)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(TapGesture().onEnded {
                            homeController.focusChannel(channel)
                        })
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
