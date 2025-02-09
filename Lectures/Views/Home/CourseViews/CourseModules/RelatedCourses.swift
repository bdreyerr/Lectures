//
//  RelatedCourses.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/1/25.
//

import SwiftUI

struct RelatedCourses: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    @EnvironmentObject var courseController: CourseController
    
    @State private var isSignInSheetShowing: Bool = false
    @State private var isUpgradeAccountSheetShowing: Bool = false
    var body: some View {
        Group {
            HStack {
                Text("Recommended Courses")
                    .font(.system(size: 14))
                    .padding(.bottom, 10)
            }
            
            if !isSignedIn {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.gray.opacity(0.3))
                
                Text("Logged in users have access to course recommendations")
                    .font(.system(size: 13, design: .serif))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                Button(action: {
                    isSignInSheetShowing = true
                }) {
                    Text("Sign Up / Sign In")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            } else {
                // user is signed in. Check pro status
                if !subscriptionController.isPro {
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.top, 40)
                    
                    Text("Pro users have access to course recommendations")
                        .font(.system(size: 13, design: .serif))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        isUpgradeAccountSheetShowing = true
                    }) {
                        Text("Upgrade")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(20)
                    }
                } else {
                    // User is Pro, view related courses
                    
                    // Skeleton Loader
                    if courseController.isRelatedCourseLoading {
                        VStack {
                            HStack {
                                SkeletonLoader(width: 350, height: 60)
                                Spacer()
                            }
                            HStack {
                                SkeletonLoader(width: 350, height: 60)
                                Spacer()
                            }
                            HStack {
                                SkeletonLoader(width: 350, height: 60)
                                Spacer()
                            }
                        }
                    } else {
                        ForEach(courseController.courseRecommendations, id: \.id) { course in
                            RelatedCourse(course: course)
                        }
                    }
                }
            }
            
        }
        .sheet(isPresented: $isSignInSheetShowing) {
            FirstOpenSignUpSheet(text: "Sign In", displaySheet: $isSignInSheetShowing)
                .presentationDetents([.fraction(0.25), .medium]) // User can drag between these heights
        }
        .sheet(isPresented: $isUpgradeAccountSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
        }
    }
}

#Preview {
    RelatedCourses()
}
