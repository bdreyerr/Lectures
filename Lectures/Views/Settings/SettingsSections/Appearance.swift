//
//  Appearance.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/20/25.
//

import SwiftUI

struct Appearance: View {
    @EnvironmentObject var userController: UserController
    
    @State var isUpgradeSheetShowing: Bool = false
    
    @State var isDarkModeEnabled = false
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("Appearance")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                if let user = userController.user, let accountType = user.accountType {
                    if accountType == 0 {
                        HStack {
                            // icon
                            Image(systemName: "wallet.pass")
                            
                            // text
                            
                            Text("Upgrade to customize app appearance")
                                .font(.system(size: 14, design: .serif))
                            
                            
                            
                            Spacer()
                            
                            // edit button
                            Button(action: {
                                isUpgradeSheetShowing = true
                            }) {
                                Text("Upgrade")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.orange)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Divider()
                    } else {
                        // Dark Mode
                        HStack {
                            // icon
                            Image(systemName: "moon")
                            
                            // text
                            
                            Text("Dark Mode")
                                .font(.system(size: 14, design: .serif))
                            
                            
                            Toggle("", isOn: $isDarkModeEnabled)
                                .padding(.trailing, 5)
                            
                            Spacer()
                            
                            
                        }
                        Divider()
                        
                        // App Icon
                        HStack {
                            // icon
                            Image(systemName: "app.badge")
                            
                            // text
                            
                            Text("App Icon")
                                .font(.system(size: 14, design: .serif))
                            
                            
                            Spacer()
                            
                            Button(action: {
                                print("user wanted to change the app icon")
                            }) {
                                Image(systemName: "square.and.pencil.circle.fill")
                                    .imageScale(.medium)
                                    .padding(.leading, 4)  // Add some space before the button
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isUpgradeSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial()
        }
    }
}

#Preview {
    Appearance()
}
