//
//  SignInWithApple.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import FirebaseAuth
import AuthenticationServices
import SwiftUI

struct SignInWithApple: View {
    // Light / Dark Theme
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var authController: AuthController
    
    var disablePadding: Bool?
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: { request in
                let nonce = authController.randomNonceString()
                authController.currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = authController.sha256(nonce)
            },
            onCompletion: { result in
                
                Task {
                    authController.appleSignInButtonOnCompletion(result: result)
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: 40)
        .cornerRadius(10)
        .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
        .padding(.horizontal, disablePadding ?? false ? 0 : 20)
    }
}

#Preview {
    SignInWithApple()
        .environmentObject(AuthController())
}
