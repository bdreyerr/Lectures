//
//  ContentView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: CustomTabBar.TabItemKind = .home
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeMainView()
            case .trends:
                MyCoursesMainView()
            case .search:
                SearchMainView()
            case .profile:
                ProfileMainView()
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
