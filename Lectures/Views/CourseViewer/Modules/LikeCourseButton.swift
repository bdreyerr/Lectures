//
//  LikeCourseButton.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import SwiftUI

struct LikeCourseButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var rateLimiter: RateLimiter
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    var courseId: String
    
    @State private var isCourseLiked: Bool = false
    @State private var isUpgradeAccountSheetShowing: Bool = false
    @State private var isProAccountButNotRegisteredSheetShowing: Bool = false
    
    var body: some View {
        Button(action: {
            // if the user isn't a PRO member, they can't like courses
            if subscriptionController.isPro {
                if let user = userController.user, let userId = user.id {
                    if let rateLimit = rateLimiter.processWrite() {
                        print(rateLimit)
                        return
                    }
                    
                    userController.likeCourse(userId: userId, courseId: courseId)
                    withAnimation(.spring()) {
                        self.isCourseLiked.toggle()
                    }
                } else {
                    isProAccountButNotRegisteredSheetShowing = true
                }
            } else {
                // show the upgrade account sheet
                self.isUpgradeAccountSheetShowing = true
            }
        }) {
            Image(systemName: isCourseLiked ? "heart.fill" : "heart")
                .font(.system(size: 18, design: .serif))
                .foregroundStyle(isCourseLiked ? Color.red : colorScheme == .light ? Color.black : Color.white)
        }
        .sheet(isPresented: $isUpgradeAccountSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
        }
        .sheet(isPresented: $isProAccountButNotRegisteredSheetShowing) {
            ProAccountButNotSignedInSheet(displaySheet: $isProAccountButNotRegisteredSheetShowing)
        }
        .onAppear {
            // Determine if the user has already liked this course or not, if they have, set the button to liked
            if let user = userController.user, let likedCourseIds = user.likedCourseIds {
                if likedCourseIds.contains(courseId) {
                    self.isCourseLiked = true
                }
            }
        }
    }
}

//#Preview {
//    LikeCourseButton()
//}
