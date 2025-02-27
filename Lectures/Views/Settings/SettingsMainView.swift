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
    
    @State var signUpSheetShowing: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                TopBrandView()
                
                ScrollView(showsIndicators: false) {
                    Text("General")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    SingleSettingsLink(iconName: "person", settingName: "Account Information", destination: AccountInformation(), disableIfSignedOut: false)
//                    SingleSettingsLink(iconName: "wallet.pass", settingName: "Subscription Type", destination: SubscriptionType(), disableIfSignedOut: false)
//                    SingleSettingsLink(iconName: "dollarsign.square", settingName: "Purchase History", destination: PurchaseHistory())
                    SingleSettingsLink(iconName: "moon", settingName: "Appearance", destination: Appearance(), disableIfSignedOut: false)
//                    SingleSettingsLink(iconName: "bell", settingName: "Notifications", destination: Notifications())
                    
                    Text("Support")
                        .font(.system(size: 15, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    
                    
                    // Leave a tip
                    SingleSettingsLink(iconName: "heart", settingName: "Support Developer", destination: SupportDeveloper(), disableIfSignedOut: false)
                    SingleSettingsLink(iconName: "exclamationmark.circle", settingName: "Report Issues", destination: ReportIssues(), disableIfSignedOut: false)
                    SingleSettingsLink(iconName: "questionmark.app", settingName: "FAQ", destination: FAQ(), disableIfSignedOut: false)
                    SingleSettingsLink(iconName: "info.circle", settingName: "Licesne Information", destination: LicenseInformation(), disableIfSignedOut: false)
                    SingleSettingsLink(iconName: "hand.raised.circle", settingName: "Privacy Policy", destination: PrivacyPolicy(), disableIfSignedOut: false)
                    ExternalSettingsLink(
                        iconName: "filemenu.and.cursorarrow",
                        settingName: "End User License Agreement (EULA)",
                        url: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") ?? URL(fileURLWithPath: "")
                    )
                    
                    
                    if !isSignedIn {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.top, 40)
                        
                        Text("You're not logged in")
                            .font(.system(size: 13, design: .serif))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            signUpSheetShowing = true
                        }) {
                            Text("Sign Up / Sign In")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .cornerRadius(20)
                        }
                        .sheet(isPresented: $signUpSheetShowing) {
                            ProAccountButNotSignedInSheet(displaySheet: $signUpSheetShowing)
                        }
                    }
                    
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
    var disableIfSignedOut: Bool
    
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
                .contentShape(Rectangle())
            }
            .disabled(disableIfSignedOut && !isSignedIn)
            .buttonStyle(PlainButtonStyle())
            
            Divider()
                .padding(.bottom, 5)
        }
    }
}

struct ExternalSettingsLink: View {
    @Environment(\.openURL) private var openURL
    
    var iconName: String
    var settingName: String
    var url: URL
    
    var body: some View {
        VStack {
            Button {
                openURL(url)
            } label: {
                HStack {
                    Image(systemName: iconName)
                    
                    Text(settingName)
                        .font(.system(size: 14, design: .serif))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right.square")
                }
            }
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
