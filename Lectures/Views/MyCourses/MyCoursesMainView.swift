//
//  MyCoursesMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct MyCoursesMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var authController: AuthController
    
    
    
    var body: some View {
        
        if !isSignedIn {
            VStack {
                Text("Please create an account or sign in to view your course history")
                    .font(.system(size: 13, design: .serif))
                    .padding(.bottom, 5)
                
                SignInWithApple()
                
                SignInWithGoogle()
            }
        } else {
            NavigationView {
                VStack {
                    TopBrandView()
                    
                    ScrollView(showsIndicators: false) {
                        // watched courses
                        WatchedCourses()
                            .padding(.top, 10)
                        
                        
                        // liked courses
                        LikedCourses()
                            .padding(.top, 10)
                        
                        
                        // recommended for you
                        RecommendedCourses()
                            .padding(.top)
                        
                        Spacer()
                        
                        // Logo
                        if (colorScheme == .light) {
                            Image("LogoTransparentWhiteBackground")
                                .resizable()
                                .frame(width: 80, height: 80)
                        } else if (colorScheme == .dark) {
                            Image("LogoBlackBackground")
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        Text("Lectura")
                            .font(.system(size: 15, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .opacity(0.8)
                        Text("version 1.1")
                            .font(.system(size: 11, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            .opacity(0.8)
                    }
                }
                .navigationBarHidden(true)
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    MyCoursesMainView()
        .environmentObject(AuthController())
}
