//
//  DeleteAccountButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//

import SwiftUI

struct DeleteAccountButton: View {
    var body: some View {
        // Delete Account
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.red, lineWidth: 1.5)
            .frame(height: 40)
            .overlay(
                Text("Delete Account")
                    .font(.system(size: 16, design: .serif))
                    .foregroundColor(.red)
            )
            .padding(.top, 10)
            .padding(.horizontal, 1)
    }
}

#Preview {
    DeleteAccountButton()
}
