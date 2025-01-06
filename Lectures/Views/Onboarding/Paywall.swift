//
//  Paywall.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/30/24.
//

import AuthenticationServices
import SwiftUI

struct Paywall: View {
    // Light / Dark Theme
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
    @EnvironmentObject var authController: AuthController
//    @State var selectedOption: Int = 0
    var body: some View {
        VStack {
            VStack {
                HStack {
                    // Small Logo
                    if (colorScheme == .light) {
                        Image("LogoTransparentWhiteBackground")
                            .resizable()
                            .frame(width: 30, height: 30)
                    } else if (colorScheme == .dark) {
                        Image("LogoBlackBackground")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Text("Welcome to Lectura")
                        .font(.system(size: 16, design: .serif))
                        .bold()
                }
                
                Text("Start your learning journey")
                    .font(.system(size: 14, design: .serif))
                    .padding(.bottom, 5)
                
                Text("Choose membership type")
                    .font(.system(size: 12, design: .serif))
                    .padding(.bottom, 20)
                
                
                HStack {
                    // free
                    MembershipOption(
                        titleText: "Free",
                        attributes: ["free access to all courses", "ads", "unlimited resources", "no personalized learning"],
                        optionIndex: 0,
                        selectedOption: $authController.selectedMembershipType
                    )
                    .padding(.horizontal, 5)
                    
                    // pro
                    MembershipOption(
                        titleText: "Plus $6.99/mo",
                        attributes: ["free access to all courses", "no ads", "unlimited resources", "course history", "course planner"],
                        optionIndex: 1,
                        selectedOption: $authController.selectedMembershipType
                    )
                    .padding(.horizontal, 5)
                    
                    // pro
//                    MembershipOption(
//                        titleText: "Pro $7.99/mo",
//                        attributes: ["no ads", "Unlimited Resources"],
//                        optionIndex: 2,
//                        selectedOption: $authController.selectedMembershipType
//                    )
//                    .padding(.horizontal, 5)
                }
                
                Text("Resource = notes, homeworks, practice exams & answers")
                    .font(.system(size: 12, design: .serif))
                
                if authController.selectedMembershipType != 0 {
                    Text("Create an account to continue")
                        .font(.system(size: 12, design: .serif))
                        .padding(.top, 5)
                }
            }
            .padding(10)
            .padding(.bottom, 10)
            .background(colorScheme == .light ? Color.white : Color.black) // Optional: Add a background color
            .cornerRadius(10) // Apply rounded corners
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 2)
            )
            .padding()
            
            
            if authController.selectedMembershipType == 0 {
                
                if authController.isFinishedSigningIn {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green, lineWidth: 1)
                        .frame(height: 40)
                        .background(Color.white)
                        .overlay(
                            Text("Continue to App")
                                .font(.system(size: 16, design: .serif))
                                .foregroundStyle(Color.green)
                                .bold()
                        )
//                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            hasUserSeenPaywall = true
                            // do some work to set the membership type on the user profile
                        }
                } else {
                    Group {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                            .frame(height: 40)
                            .background(Color.white)
                            .overlay(
                                Text("Continue without account")
                                    .font(.system(size: 16, design: .serif))
                                    .foregroundStyle(Color.blue)
                                    .bold()
                            )
                        //                        .padding(.top, 20)
                            .padding(.horizontal, 20)
                            .onTapGesture {
                                hasUserSeenPaywall = true
                            }
                        
                        SignInWithApple()
                        
                        SignInWithGoogle()
                    }
                }
            } else {
                // show the sign in buttons if the user has not yet signed in, otherwise prompt the user to purchase their subcription
                
                if authController.isFinishedSigningIn {
                    // place holder purchase button
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green, lineWidth: 1)
                        .frame(height: 40)
                        .background(Color.white)
                        .overlay(
                            Text("Complete Purchase")
                                .font(.system(size: 16, design: .serif))
                                .foregroundStyle(Color.green)
                                .bold()
                        )
//                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            hasUserSeenPaywall = true
                            
                            
                            // do some work to set the membership type on the user profile
                        }
                } else {
                    SignInWithApple()
                    
                    SignInWithGoogle()
                }
            }
        }
        .padding(.bottom, 200)
    }
}

struct MembershipOption: View {
    var titleText: String
    var attributes: [String]
    var optionIndex: Int
    @Binding var selectedOption: Int
    
    var body: some View {
        VStack {
            Text(titleText)  // Fixed to use titleText instead of hardcoded value
                .font(.system(size: 11, design: .serif))
                .bold()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            ForEach(attributes, id: \.self) { attribute in
                Text("- \(attribute)")
                    .font(.system(size: 11, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.bottom, 20)
        .padding(10)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selectedOption == optionIndex ? Color.blue : Color.black, lineWidth: 2)
        )
        .scaleEffect(selectedOption == optionIndex ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedOption)
        .onTapGesture {
            selectedOption = optionIndex
        }
    }
}

#Preview {
    Paywall()
        .environmentObject(AuthController())
}
