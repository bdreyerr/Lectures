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
    
    //    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var myCourseController: MyCourseController
    
    @State var upgradeAccountSheetShowing: Bool = false
    
    var body: some View {
        if !isSignedIn {
            VStack {
                TopBrandView()
                    .padding(.horizontal, 20)
                
                Text("Sign in to see course history")
                    .font(.system(size: 13, design: .serif))
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    
                
                SignInWithApple(displaySignInSheet: .constant(false))
                
                SignInWithGoogle(displaySignInSheet: .constant(false))
                    
                Spacer()
            }
        } else {
            NavigationView {
                VStack {
                    TopBrandView()
                    
                    ScrollView(showsIndicators: false) {
                        
                        if let user = userController.user {
                            if user.accountType! == 0 {
                                // Free user, show the paywall and tell them they can't access this feature
                                Text("Upgrade your account to access watch history and personalized learning features")
                                    .font(.system(size: 14, design: .serif))
                                    .padding(.top, 40)
                                    .multilineTextAlignment(.center) 
                                
                                Button(action: {
                                    upgradeAccountSheetShowing = true
                                }) {
                                    Text("Upgrade to PRO")
                                        .font(.system(size: 16, design: .serif))
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.green.opacity(0.8))
                                        .cornerRadius(10)
                                }
                                .padding(.horizontal, 30)
                                .sheet(isPresented: $upgradeAccountSheetShowing) {
                                    UpgradeAccountPaywallWithoutFreeTrial()
                                }
                            } else {
                                MyCoursesProUserView()
                            }
                        }
                        
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
