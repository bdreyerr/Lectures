//
//  FirstOpenSignUpSheet.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/14/25.
//

import SwiftUI

struct FirstOpenSignUpSheet: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var userController: UserController
    
    var text: String
    @Binding var displaySheet: Bool
    var body: some View {
        ZStack {
//            LatticeBackground()
            VStack {
                if isSignedIn {
                    Text("You're signed in :)")
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(Color.green)
                    
                    Text("You can close this tab and continue")
                        .font(.system(size: 16, design: .serif))
                } else {
                    Text(text)
                        .font(.system(size: 16, design: .serif))
                        
                    SignInWithApple(displaySignInSheet: $displaySheet)
                    SignInWithGoogle(displaySignInSheet: $displaySheet)
                        .onDisappear {
                            displaySheet = false
                        }
                }
            }
        }
    }
}

#Preview {
    FirstOpenSignUpSheet(text: "arg", displaySheet: .constant(false))
}
