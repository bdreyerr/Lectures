//
//  SignUpOrIn.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/30/24.
//

import SwiftUI
import AuthenticationServices

struct SignUpOrInOutsideOfPaywall: View {
    // Light / Dark Theme
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var authController: AuthController
    
    var body: some View {
        VStack {
            HStack {
                // Small Logo
                if (colorScheme == .light) {
                    Image("LogoTransparentWhiteBackground")
                        .resizable()
                        .frame(width: 30, height: 30)
                } else if (colorScheme == .dark) {
                    Image("LogoBlackBackground")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Text("Lectura")
                    .font(.system(size: 16, design: .serif))
                    .bold()
            }
            
            Text("Start your learning journey")
                .font(.system(size: 14, design: .serif))
                .padding(.bottom, 5)
            
            Text("Create an account today")
                .font(.system(size: 12, design: .serif))
                .padding(.bottom, 20)
            
            SignInWithAppleButton(
                onRequest: { request in
//                    let nonce = authController.randomNonceString()
//                    authController.currentNonce = nonce
//                    request.requestedScopes = [.fullName, .email]
//                    request.nonce = authController.sha256(nonce)
                },
                onCompletion: { result in
//                    if let rateLimit = userController.processFirestoreWrite() {
//                        print(rateLimit)
//                    } else {
//                        Task {
//                            authController.appleSignInButtonOnCompletion(result: result)
//                        }
//                    }
                }
            )
            .frame(maxWidth: 250, maxHeight: 40)
            .cornerRadius(10)
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            
            // Sign in with Google Button
            Button(action: {
                // sign in with google
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .frame(width: 18, height: 18)
                    Text("Sign in with Google")
                    //                            .font(.headline)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                .frame(width: 250, height: 40)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
                .cornerRadius(10)
            }
            
            HStack {
                Text("Already have an account? Use the methods above to Login")
                    .font(.system(size: 12, design: .serif))
//                Text("Log in")
//                    .font(.system(size: 12, design: .serif))
//                    .foregroundStyle(Color.blue)
            }
            .padding(.top, 10)
        }
        .padding(20)
        .padding(.bottom, 40)
        .background(colorScheme == .light ? Color.white : Color.black) // Optional: Add a background color
        .cornerRadius(10) // Apply rounded corners
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 2)
        )
        .padding()
    }
}

#Preview {
    SignUpOrInOutsideOfPaywall()
        .environmentObject(AuthController())
}
