//
//  Support the Developer.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/27/25.
//

import SwiftUI
import StoreKit


struct SupportDeveloper: View {
    // Light / Dark Theme
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    
    @State private var showTipAlert = false
    
    func requestAppReview() {
        requestReview()
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Text("Support Developer")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                VStack(spacing: 15) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                        .padding(.top, 20)
                    
                    Text("This app is offered for free by a single developer")
                        .font(.system(size: 16, design: .serif))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Your support is greatly appreciated and helps keep the app running and improving.")
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        if let url = URL(string: "https://buymeacoffee.com/bendreyer") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image("bmc-button")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                            
                            Text("Leave a Tip")
                                .font(.system(size: 16, design: .serif))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.yellow.opacity(0.2))
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.yellow, lineWidth: 1)
                        )
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Text("Rate on the App Store")
                            .font(.system(size: 14, design: .serif))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .onTapGesture {
                        requestAppReview()
                    }
                    
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        
                        Text("Contact Developer")
                            .font(.system(size: 14, design: .serif))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.3))
                    .cornerRadius(10)
                    .onTapGesture {
                        if let url = URL(string: "mailto:lecturalearning@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SupportDeveloper()
}
