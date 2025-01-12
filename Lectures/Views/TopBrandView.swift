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
//                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack {
                Text("Lectura")
                    .font(.system(size: 16, design: .serif))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TimeBasedGreeting()
            }
            
            Spacer()
            
            Text(Date().formatted(.dateTime.month().day()))
                .font(.system(size: 14, design: .serif))
        }
        .cornerRadius(5)
    }
}

struct TimeBasedGreeting: View {
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
    var body: some View {
        Text("\(greeting), Ben")
            .font(.system(size: 10, design: .serif))
            .opacity(0.6)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TopBrandView()
}
