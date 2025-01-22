//
//  SettingsMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/29/24.
//

import SwiftUI

struct SettingsMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    // App Storage: isSignedIn tracks auth status throughout app
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var authController: AuthController
    var body: some View {
        NavigationView {
            VStack {
                TopBrandView()
                
                if !isSignedIn {
                    SignInWithApple(displaySignInSheet: .constant(false))
                        .padding(.top, 20)
                    
                    SignInWithGoogle(displaySignInSheet: .constant(false))
                }
                
                ScrollView(showsIndicators: false) {
                    
                    Text("General")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    SingleSettingsLink(iconName: "person", settingName: "Account Information", destination: AccountInformation())
                    SingleSettingsLink(iconName: "wallet.pass", settingName: "Subscription Type", destination: SubscriptionType())
                    SingleSettingsLink(iconName: "dollarsign.square", settingName: "Purchase History", destination: PurchaseHistory())
                    SingleSettingsLink(iconName: "moon", settingName: "Appearance", destination: Appearance())
                    SingleSettingsLink(iconName: "bell", settingName: "Notifications", destination: Notifications())
                    
                    Text("Support")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    
                    SingleSettingsLink(iconName: "exclamationmark.circle", settingName: "Report Issues", destination: ReportIssues())
                    SingleSettingsLink(iconName: "questionmark.app", settingName: "FAQ", destination: FAQ())
                    SingleSettingsLink(iconName: "info.circle", settingName: "Licesne Information", destination: LicenseInformation())
                    SingleSettingsLink(iconName: "hand.raised.circle", settingName: "Privacy Policy", destination: PrivacyPolicy())
                    
                    
                    
                    if isSignedIn {
                        SignOutButton()
                        
                        DeleteAccountButton()
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
        }
        // Needed for iPad compliance
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SingleSettingsLink<Destination: View>: View {
    // App Storage: isSignedIn tracks auth status throughout app
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    var iconName: String
    var settingName: String
    var destination: Destination
    
    var body: some View {
        VStack {
            NavigationLink(destination: destination) {
                HStack {
                    // icon
                    Image(systemName: iconName)
                    
                    // text
                    Text(settingName)
                        .font(.system(size: 14, design: .serif))
                    
                    Spacer()
                    // arrow
                    
                    Image(systemName: "chevron.right")
                }
            }
            .disabled(!isSignedIn)
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .padding(.bottom, 5)
        }
        
    }
}

#Preview {
    SettingsMainView()
        .environmentObject(AuthController())
}
