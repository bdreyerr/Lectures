//
//  AccountInformation.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import FirebaseAuth
import SwiftUI

struct AccountInformation: View {
    // Light / Dark Theme
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userController: UserController
    
    @State private var signInMethod: String?
    var body: some View {
        VStack {
            // Today's Prompt and Change Date Button
            HStack {
                if (colorScheme == .light) {
                    Image("LogoTransparentWhiteBackground")
                        .resizable()
                        .frame(width: 30, height: 30)
                } else if (colorScheme == .dark) {
                    Image("LogoBlackBackground")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Text("|   Lectura")
                    .font(.system(size: 16, design: .serif))
                    .bold()
                
                Spacer()
                
                Text(Date().formatted(.dateTime.month().day()))
                    .font(.system(size: 14, design: .serif))
            }
            // Adding this seems to stop the weird expansion of this section when switching tabs
            .overlay {
                Rectangle()
                    .stroke(Color.black, lineWidth: 0)
            }
            
            ScrollView(showsIndicators: false) {
                Text("Settings")
                    .font(.system(size: 24, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 40)
                
                Text("Account Information")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                
                if let user = userController.user {
                    // name
                    HStack {
                        // icon
                        Image(systemName: "person")
                        
                        // text
                        if let firstName = user.firstName, let lastName = user.lastName {
                            Text("\(firstName) \(lastName)")
                                .font(.system(size: 14, design: .serif))
                        }
                        
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    // email
                    HStack {
                        // icon
                        Image(systemName: "envelope")
                        
                        // text
                        if let email = user.email {
                            Text(email)
                                .font(.system(size: 14, design: .serif))
                        }
                        Spacer()
                    }
                    
                    Divider()
                    
                    // signin method
                    if let signInMethod = self.signInMethod {
                        HStack {
                            // image
                            if signInMethod == "Google" {
                                Image("google_logo")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            } else {
                                Image(systemName: "apple.logo")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            
                            Text("Authenticated with ")
                                .font(.system(size: 14, design: .serif))
                            
                            if signInMethod == "Google" {
                                Text("Google")
                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                            } else {
                                Text("Apple")
                                    .font(.system(size: 14, design: .serif))
                                    .bold()
                            }
                            
                            Spacer()
                        }
                    }
                    
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            if let provider = getSignInProvider() {
                print("User signed in with: \(provider)")
                self.signInMethod = provider
            }
        }
    }
        
    
    func getSignInProvider() -> String? {
        guard let user = Auth.auth().currentUser,
              let providerData = user.providerData.first else {
            return nil
        }
        
        switch providerData.providerID {
        case "google.com":
            return "Google"
        case "apple.com":
            return "Apple"
        default:
            return providerData.providerID
        }
    }
}

#Preview {
    AccountInformation()
        .environmentObject(UserController())
}
