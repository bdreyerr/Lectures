//
//  ChannelSerachResult.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/19/25.
//

import SwiftUI

struct ChannelSearchResult: View {
    @EnvironmentObject var courseController: CourseController
    
    var channel: Channel
    var body: some View {
        
        VStack {
            ChannelCard(channel: channel)
        }
        .padding(.top, 6)
    }
}

//#Preview {
//    ChannelSearchResult()
//}
