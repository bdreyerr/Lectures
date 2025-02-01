//
//  SignInWithGoogle.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import SwiftUI

struct SignInWithGoogle: View {
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
    @EnvironmentObject var authController: AuthController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    var disablePadding: Bool?
    @Binding var displaySignInSheet: Bool
    
    var closePaywallOnSignIn: Bool?
    
    
    var body: some View {
        // Sign in with Google Button
        Button(action: {
            Task {
                // sign in with google
                authController.signInWithGoogle(displaySignInSheet: $displaySignInSheet)
                // restore purchases with revenue cat (will return the user's pro status)
                await subscriptionController.restorePurchases()
                
                if let _ = closePaywallOnSignIn {
                    hasUserSeenPaywall = true
                }
            }
        }) {
            HStack {
                Image("google_logo")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("Sign in with Google")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            .cornerRadius(10)
        }
        .padding(.horizontal, disablePadding ?? false ? 0 : 20 )
    }
}

#Preview {
    SignInWithGoogle(displaySignInSheet: .constant(false))
        .environmentObject(AuthController())
}
