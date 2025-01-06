//
//  TopBrandView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import SwiftUI

struct TopBrandView: View {
    
    var body: some View {
        HStack {
            Image("lectura-icon")
                .resizable()
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            
            Text("|  Lectura")
                .font(.system(size: 16, design: .serif))
                .bold()
            
            Spacer()
            
            Text(Date().formatted(.dateTime.month().day()))
                .font(.system(size: 14, design: .serif))
        }
    }
}

#Preview {
    TopBrandView()
}
