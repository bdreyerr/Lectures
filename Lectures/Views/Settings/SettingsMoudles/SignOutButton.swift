//
//  SignOutButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import SwiftUI

struct SignOutButton: View {
    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        // Log Out
        Button(action: {
            // Sign out of account - auth
            authController.logOut()
            userController.logOut()
        }) {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
                .frame(height: 40)
                .overlay(
                    Text("Log Out")
                        .font(.system(size: 16, design: .serif))
                )
                .padding(.top, 30)
                .padding(.horizontal, 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
