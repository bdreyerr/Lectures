//
//  SignInWithGoogle.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import SwiftUI

struct SignInWithGoogle: View {
    @EnvironmentObject var authController: AuthController
    
    var disablePadding: Bool?
    var body: some View {
        // Sign in with Google Button
        Button(action: {
            // sign in with google
            authController.signInWithGoogle()
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
    SignInWithGoogle()
        .environmentObject(AuthController())
}
