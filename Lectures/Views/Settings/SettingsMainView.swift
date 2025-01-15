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
                
                ScrollView(showsIndicators: false) {
                    Text("Settings")
                        .font(.system(size: 24, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.bottom, 40)
                    
                    Text("General")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.bottom, 10)
                    
                    SingleSettingsLink(iconName: "person", settingName: "Account Information", destination: AccountInformation())
                    SingleSettingsLink(iconName: "wallet.pass", settingName: "Subscription Type", destination: HomeMainView())
                    SingleSettingsLink(iconName: "dollarsign.square", settingName: "Purchase History", destination: HomeMainView())
                    SingleSettingsLink(iconName: "moon", settingName: "Appearance", destination: HomeMainView())
                    SingleSettingsLink(iconName: "bell", settingName: "Notifications", destination: HomeMainView())
                    
                    Text("Support")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    
                    SingleSettingsLink(iconName: "exclamationmark.triangle", settingName: "Report an Issue", destination: HomeMainView())
                    SingleSettingsLink(iconName: "phone", settingName: "Get Help", destination: HomeMainView())
                    SingleSettingsLink(iconName: "questionmark.app", settingName: "FAQ", destination: HomeMainView())
                    SingleSettingsLink(iconName: "info.circle", settingName: "Licesne Information", destination: HomeMainView())
                    SingleSettingsLink(iconName: "hand.raised.circle", settingName: "Privacy Policy", destination: HomeMainView())
                    
                    
                    
                    if isSignedIn {
                        SignOutButton()
                        
                        DeleteAccountButton()
                    } else {
                        SignInWithApple(disablePadding: true, displaySignInSheet: .constant(false))
                            .padding(.top, 20)
                        
                        SignInWithGoogle(disablePadding: true, displaySignInSheet: .constant(false))
                    }
                    
                    // Logo
                    if (colorScheme == .light) {
                        Image("LogoTransparentWhiteBackground")
                            .resizable()
                            .frame(width: 80, height: 80)
                    } else if (colorScheme == .dark) {
                        Image("LogoBlackBackground")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    Text("Lectura")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .opacity(0.8)
                    Text("version 1.1")
                        .font(.system(size: 11, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .opacity(0.8)
                }
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 20)
        }
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
