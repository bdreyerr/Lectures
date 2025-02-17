//
//  ProAccountButNotSignedInSheet.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/17/25.
//

import SwiftUI

struct ProAccountButNotSignedInSheet: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @Binding var displaySheet: Bool
    var body: some View {
        VStack(spacing: 20) {
            
            if isSignedIn {
                Text("You're signed in :)")
                    .font(.system(size: 16, design: .serif))
                    .foregroundStyle(Color.green)
                
                Text("You can close this tab and continue")
                    .font(.system(size: 16, design: .serif))
            } else {
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Account Required")
                    .font(.title2)
                    .bold()
                
                Text("You have a Pro subscription, but we need you to create an account or sign in to save your preferences and history.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                    
                SignInWithApple(displaySignInSheet: $displaySheet)
                SignInWithGoogle(displaySignInSheet: $displaySheet)
                    .onDisappear {
                        displaySheet = false
                    }
            }
        }
        .padding()
    }
}

//#Preview {
//    ProAccountButNotSignedInSheet()
//}
