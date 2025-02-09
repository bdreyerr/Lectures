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
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
    @EnvironmentObject var authController: AuthController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    var disablePadding: Bool?
    @Binding var displaySignInSheet: Bool
    
    var closePaywallOnSignIn: Bool?
    
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
                    
                    if let closePaywallOnSignIn = closePaywallOnSignIn, closePaywallOnSignIn == true {
                        authController.appleSignInButtonOnCompletion(result: result, displaySignInSheet: $displaySignInSheet, closePaywallOnSignIn: true)
                    } else {
                        authController.appleSignInButtonOnCompletion(result: result, displaySignInSheet: $displaySignInSheet, closePaywallOnSignIn: false)
                    }
                    
                    // restore purchases with revenue cat (will return the user's pro status)
                    await subscriptionController.restorePurchases()
                    
//                    if let _ = closePaywallOnSignIn {
//                        hasUserSeenPaywall = true
//                    }
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
    SignInWithApple(displaySignInSheet: .constant(false))
        .environmentObject(AuthController())
}
