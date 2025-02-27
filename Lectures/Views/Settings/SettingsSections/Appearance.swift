//
//  Appearance.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/20/25.
//

import SwiftUI

struct Appearance: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @State var isUpgradeSheetShowing: Bool = false
    
    @State private var selectedIcon: String? = nil
    private let appIcons = [
        (name: "Default", iconName: nil),
        (name: "Dark", iconName: "AppIconDark"),
        (name: "Light", iconName: "AppIconLight")
    ]
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("Appearance")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                // Dark Mode
                HStack {
                    // icon
                    Image(systemName: "moon")
                    
                    // text
                    
                    Text("Dark Mode")
                        .font(.system(size: 14, design: .serif))
                    
                    
                    Toggle("", isOn: $isDarkMode)
                        .padding(.trailing, 5)
                        .onChange(of: isDarkMode) { newValue in
                            // Code to run when the toggle changes
                            if newValue {
                                isDarkMode = true
                            } else {
                                isDarkMode = false
                            }
                        }
                    
                    
                    Spacer()
                    
                    
                }
                Divider()
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isUpgradeSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeSheetShowing)
        }
    }
}

#Preview {
    Appearance()
}
