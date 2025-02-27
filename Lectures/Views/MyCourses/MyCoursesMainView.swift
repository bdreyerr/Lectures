//
//  MyCoursesMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import FirebaseAuth
import SwiftUI

struct MyCoursesMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    //    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    @State var signUpSheetShowing: Bool = false
    @State var upgradeAccountSheetShowing: Bool = false
    var body: some View {
        if !isSignedIn {
            VStack {
                TopBrandView()
                    .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.top, 40)
                    
                    Text("Logged in users have access to course history and more")
                        .font(.system(size: 13, design: .serif))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        signUpSheetShowing = true
                    }) {
                        Text("Sign Up / Sign In")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                    .sheet(isPresented: $signUpSheetShowing) {
                        ProAccountButNotSignedInSheet(displaySheet: $signUpSheetShowing)
                    }
                }
                .padding(.top, 40)
                
                // SignInWithApple(displaySignInSheet: .constant(false))
                
                // SignInWithGoogle(displaySignInSheet: .constant(false))
                    
                Spacer()
            }
        } else {
            NavigationView {
                VStack {
                    TopBrandView()
                    
                    ScrollView(showsIndicators: false) {
                        
                        MyCoursesProUserView()
                        
                        
                        Spacer()
                        
                        BottomBrandView()
                    }
                }
                .navigationBarHidden(true)
                .padding(.horizontal, 20)
            }
            // Needed for iPad compliance
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    MyCoursesMainView()
        .environmentObject(UserController())
}
