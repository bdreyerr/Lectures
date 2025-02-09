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
                        FirstOpenSignUpSheet(text: "", displaySheet: $signUpSheetShowing)
                            .presentationDetents([.fraction(0.25), .medium]) // User can drag between these heights
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
                        
                        if !subscriptionController.isPro {
                            VStack(spacing: 16) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray.opacity(0.3))
                                    .padding(.top, 40)
                                
                                Text("Pro users have access to course history and more")
                                    .font(.system(size: 13, design: .serif))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)

                                Button(action: {
                                    upgradeAccountSheetShowing = true
                                }) {
                                    Text("Upgrade")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.orange.opacity(0.8))
                                        .cornerRadius(20)
                                }
                                .sheet(isPresented: $upgradeAccountSheetShowing) {
                                    UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $upgradeAccountSheetShowing)
                                }
                            }
                            .padding(.top, 40)
                        } else {
                            MyCoursesProUserView()
                        }
                        
                        
                        
                        if let user = userController.user {
                            
                            
                            
                            
//                            if user.accountType! == 0 {
//                                // Free user, show the paywall and tell them they can't access this feature
//                                Text("Upgrade your account to access watch history and personalized learning features")
//                                    .font(.system(size: 14, design: .serif))
//                                    .padding(.top, 40)
//                                    .multilineTextAlignment(.center) 
//                                
//                                Button(action: {
//                                    upgradeAccountSheetShowing = true
//                                }) {
//                                    Text("Upgrade to PRO")
//                                        .font(.system(size: 16, design: .serif))
//                                        .bold()
//                                        .foregroundColor(.white)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(Color.green.opacity(0.8))
//                                        .cornerRadius(10)
//                                }
//                                .padding(.horizontal, 30)
//                                .sheet(isPresented: $upgradeAccountSheetShowing) {
//                                    UpgradeAccountPaywallWithoutFreeTrial()
//                                }
//                            } else {
//                                MyCoursesProUserView()
//                            }
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
