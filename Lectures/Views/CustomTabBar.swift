//
//  CustomTabBar.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct CustomTabBar: View {
  
  enum TabItemKind: Int, Identifiable {
    var id: Int {
      self.rawValue
    }
    
    case home = 0
    case trends
    case search
    case settings
  }
  
  struct TabItem {
    let imageName: String
    let type: TabItemKind
  }
  
  private let items = [
    TabItem(imageName: "house", type: .home),
    TabItem(imageName: "book.pages", type: .trends),
    TabItem(imageName: "magnifyingglass", type: .search),
    TabItem(imageName: "gearshape", type: .settings)
  ]
  
  @Binding var selectedTab: TabItemKind
  @State private var scale = 1.0
  
  private let tabItemWidth = 60.0
  private let indicatorColor = Color(red: 224/255.0, green: 103/255.0, blue: 111/255.0)
  
  var body: some View {
    
    ZStack {
      HStack {
        Spacer()
        
        ForEach(items, id: \.type) { item in
          Image(systemName: item.imageName)
            .frame(width: tabItemWidth, height: tabItemWidth)
          // to make the full frame tappable, not just the image
            .contentShape(Rectangle())
            .scaleEffect(selectedTab == item.type ? scale : 1.0)
            .symbolVariant(selectedTab == item.type ? .fill : .none)
            .foregroundStyle(selectedTab == item.type ? .primary : .secondary)
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                selectedTab = item.type
                scale = 1.1
              }
            }
          
          Spacer()
        }
      }
      
      VStack(alignment: .leading) {
        // Push indicator to the bottom
        Spacer()
        HStack {
          // Leading dynamic spacing
          leadingSpacers()
          
          Capsule()
            .frame(width: 32, height: 3)
            .offset(y: -3)
            .foregroundStyle(indicatorColor)
            .padding(.horizontal, 14)
            .shadow(color: indicatorColor, radius: 5, x: 0, y: -1)
          
          // Trailing dynamic spacing
          trailingSpacers()
        }
      }
      .frame(maxWidth: .infinity)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 64)
    .background(.thickMaterial.opacity(0.95), in: .capsule)
//    .background(.thickMaterial)
    .shadow(color: .black.opacity(0.6), radius: 0.0, y: 0.5)
    .padding()
  }
  
  @ViewBuilder
  func leadingSpacers() -> some View {
    let leadingMaxIndex = selectedTab.rawValue + 1
    ForEach(0..<leadingMaxIndex, id: \.self) { _ in
      Spacer()
    }
    Spacer().frame(width: tabItemWidth * CGFloat((leadingMaxIndex - 1)))
  }
  
  @ViewBuilder
  func trailingSpacers() -> some View {
    let trailingMaxIndex = items.count - selectedTab.rawValue
    ForEach(0..<trailingMaxIndex, id: \.self) { _ in
      Spacer()
    }
    Spacer().frame(width: tabItemWidth * CGFloat(trailingMaxIndex - 1))
  }
}

struct CustomTabBarPreviewWrapper: View {
    @State private var selectedTab: CustomTabBar.TabItemKind = .home

    var body: some View {
        CustomTabBar(selectedTab: $selectedTab)
    }
}

#Preview {
    CustomTabBarPreviewWrapper()
}
