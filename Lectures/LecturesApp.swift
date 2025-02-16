//
//  LecturesApp.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/15/24.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import RevenueCat
import RevenueCatUI
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // TODO: change to info for prod build
        Purchases.logLevel = .info

        // If we have the auth'd user at app launch, configure RevenueCat using the auth'd user. 
        // Otherwise, continue anonymously, and use revenue cat login function when signing a user in via auth.
        if let user = Auth.auth().currentUser {
            Purchases.configure(withAPIKey: Secrets().revenueCatProjectKey, appUserID: user.uid)
            print("on app launch and we are setting up revenue cat with firebase auth id")
        } else {
            Purchases.configure(withAPIKey: Secrets().revenueCatProjectKey)
            print("we don't have the auth user, using anonymous id for revenue cat. Call the login function later")
        }
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct LecturesApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    // App Storage: isDarkMode variable tracks dark theme throughout the app
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // App Storage: isSignedIn tracks auth status throughout app
    @AppStorage("isSignedIn") private var isSignedIn = false
    
//    @AppStorage("numActionsInLastMinute") private var numActionsInLastMinute = 0
//    @AppStorage("firstActionDate") private var firstActionDate = Date()
    
    // App Storage: isSignedIn tracks auth status throughout app
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false

    // App Storage: Rate limiting variables
    @AppStorage("numActionsInLastMinute") private var numActionsInLastMinute: Int = 0
    @AppStorage("firstActionDate") private var firstActionDateTimeInterval: Double?
    @AppStorage("numberBreach") private var numberBreach: Int = 0
    @AppStorage("lastBreachTimeInterval") private var lastBreachTimeInterval: Double?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .presentPaywallIfNeeded(
//                    requiredEntitlementIdentifier: "pro",
//                    purchaseCompleted: { customerInfo in
//                        print("Purchase completed: \(customerInfo.entitlements)")
//                    },
//                    restoreCompleted: { customerInfo in
//                        // Paywall will be dismissed automatically if "pro" is now active.
//                        print("Purchases restored: \(customerInfo.entitlements)")
//                    }
//                )
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
