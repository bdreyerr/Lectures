//
//  CategoryFilterPill.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/19/25.
//

import SwiftUI

struct CategoryFilterPill: View {
    @EnvironmentObject var searchController: SearchController
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    var text: String
    var accountType: Int?
    
    @State private var isSelected: Bool = false
    @State var isUpgradeAccountPopupShowing: Bool = false
    
    var body: some View {
        Button(action: {
            if !subscriptionController.isPro {
                isUpgradeAccountPopupShowing = true
            } else {
                // Action for the button
                withAnimation(.spring()) {
                    // either add or remove this category from the list in the controller
                    if isSelected {
                        // remove
                        searchController.activeCategories.removeAll { $0 == text }
                    } else {
                        // add
                        searchController.activeCategories.append(text)
                    }
                    
                    isSelected.toggle()
                }
            }
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 11, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background( isSelected ? Color.orange.opacity(0.6) : Color(UIColor.systemGray5))
            .foregroundColor(.primary)
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle()) // To prevent default button styling
        .sheet(isPresented: $isUpgradeAccountPopupShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountPopupShowing)
        }
    }
}

//#Preview {
//    CategoryFilterPill()
//}
