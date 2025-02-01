//
//  LecturesApp.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/15/24.
//

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
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Secrets().revenueCatProjectKey)
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
    
    // App Storage: isSignedIn tracks auth status throughout app
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
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
