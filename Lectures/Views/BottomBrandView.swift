//
//  BottomBrandView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/24/25.
//

import SwiftUI

struct BottomBrandView: View {
    var body: some View {
        // Logo
        VStack {
//            Image("AppIconLight")
//                .resizable()
//                .frame(width: 80, height: 80)
//                .cornerRadius(5)
//                .opacity(0.5)
            Text("Lectura")
                .font(.system(size: 15, design: .serif))
                .frame(maxWidth: .infinity, alignment: .bottom)
                .opacity(0.6)
            Text("version 1.1")
                .font(.system(size: 11, design: .serif))
                .frame(maxWidth: .infinity, alignment: .bottom)
                .opacity(0.6)
        }
        .padding(.top, 60)
    }
}

#Preview {
    BottomBrandView()
}
