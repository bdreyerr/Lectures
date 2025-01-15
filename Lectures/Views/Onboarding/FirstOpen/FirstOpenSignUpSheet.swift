//
//  FirstOpenSignUpSheet.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/14/25.
//

import SwiftUI

struct FirstOpenSignUpSheet: View {
    
    var text: String
    @Binding var displaySheet: Bool
    var body: some View {
        ZStack {
            LatticeBackground()
            VStack {
                
                Text(text)
                    .font(.system(size: 16, design: .serif))
                
                SignInWithApple(displaySignInSheet: $displaySheet)
                SignInWithGoogle(displaySignInSheet: $displaySheet)
            }
        }
    }
}

#Preview {
    FirstOpenSignUpSheet(text: "arg", displaySheet: .constant(false))
}
