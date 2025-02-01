//
//  UpgradeAccountPaywallWithoutFreeTrial.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/14/25.
//

import SwiftUI
import RevenueCat

struct UpgradeAccountPaywallWithoutFreeTrial: View {
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @EnvironmentObject var userController: UserController
    
    @State private var selectedPlan: String = "3 months" // Default selected plan
    
    @State private var selectedPackage: Package?
    
    @State private var showProFeaturesSheet: Bool = false
    @State private var showSignUpSheet: Bool = false
    @State private var showNoPackageSelectedAlert = false
    @State private var showAlreadCreatedAccountSignInSheet: Bool = false
    
    @Binding var sheetShowingView: Bool
    
    
    
    var body: some View {
        ZStack {
            LatticeBackground()
            
            VStack() {
                ScrollView(showsIndicators: false ) {
                    // Header with logo and title
                    VStack {
                        // Logo and app details
                        HStack {
                            Image("lectura-icon")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text("Lectura")
                                    .font(.system(size: 18, design: .serif))
                                Text("Learn Anything")
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.6)
                            }
                        }
                        .cornerRadius(5)
                        .padding(.top, 20)
                    }
                    .padding(.top, 40)
                    
                    
                    Button(action: {
                        showProFeaturesSheet = true
                    }) {
                        HStack {
                            Text("Discover the advantages with")
                                .foregroundColor(.white)
                                .font(.system(size: 16, design: .serif))
                            
                            Text("PRO")
                                .foregroundColor(.orange)
                                .font(.system(size: 14, design: .serif))
                                .bold()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.white))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showProFeaturesSheet) {
                        ProFeaturesSheet()
                    }
                    .padding(.top, 10)
                    
                    Text("Select your plan")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                    if subscriptionController.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else if let error = subscriptionController.error {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        // Subscription plans
                        VStack(spacing: 15) {
                            ForEach(subscriptionController.packages, id: \.identifier) { package in
//                                Text(package.identifier)
                                SubscriptionPlanView(
                                    title: package.storeProduct.subscriptionPeriod?.periodTitle ?? "",
                                    price: package.localizedPriceString,
                                    subPrice: calculateSubprice(for: package),
                                    discount: calculateDiscount(for: package),
                                    isSelected: selectedPackage?.identifier == package.identifier
                                ) {
                                    selectedPackage = package
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Upgrade account
                    Button(action: {
                        // Before the user can complete a purchase, force them to authenticate
                        if !isSignedIn {
                            showSignUpSheet = true
                        } else {
                            // otherwise you are signed in, and we can make the purhcase
                            print("auth'd user ready for purchase, user: ", userController.user!.id!)
                            guard let package = selectedPackage else {
                                showNoPackageSelectedAlert = true
                                return
                            }
                            
                            Task {
                                if await subscriptionController.purchase(package: package) {
                                    // if this is first open, hide the paywall
                                    hasUserSeenPaywall = true
                                    
                                    // if there was a binding passed which controlled whether or not upgrade sheet is shown, close the sheet.
                                    sheetShowingView = false
                                }
                            }
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .alert("No Plan Selected", isPresented: $showNoPackageSelectedAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("Please select a subscription plan to continue.")
                    }
                    .disabled(subscriptionController.isLoading)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    .sheet(isPresented: $showSignUpSheet) {
                        FirstOpenSignUpSheet(text: "Create an account to continue", displaySheet: $showSignUpSheet)
                            .presentationDetents([.fraction(0.4), .medium]) // User can drag between these heights
                    }
                    
                    // Continue with free account - only show if there is no signed in user right now
                    if (userController.user == nil || !isSignedIn) && !hasUserSeenPaywall  {
                        Button(action: {
                            hasUserSeenPaywall = true
                        }) {
                            Text("Continue with Free Account")
                                .font(.system(size: 16, design: .serif))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.8))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                    }
                    
                    // Restore purchases button
//                    Button(action: {
//                        Task {
//                            await subscriptionController.restorePurchases()
//                            if subscriptionController.isPro {
//                                hasUserSeenPaywall = true
//                            }
//                        }
//                    }) {
//                        Text("Restore Purchases")
//                            .font(.system(size: 14, design: .serif))
//                            .foregroundColor(.blue)
//                    }
//                    .padding(.top, 10)
                    
                    
                    Text("You can cancel the subscription at any time from the app store at no additional cost. If you do not cancel it before the end of the current period, you will be charged.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    
                    // already have an account
                    if !isSignedIn {
                        Button(action: {
                            showAlreadCreatedAccountSignInSheet = true
                        }) {
                            Text("Already have an account? Sign in instead")
                                .font(.system(size: 14, design: .serif))
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showAlreadCreatedAccountSignInSheet) {
                            VStack {
                                SignInWithApple(displaySignInSheet: .constant(false), closePaywallOnSignIn: true)
                                SignInWithGoogle(displaySignInSheet: .constant(false), closePaywallOnSignIn: true)
                            }
                            .presentationDetents([.fraction(0.4), .medium]) // User can drag between these heights
                        }
                    }
                }
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func calculateDiscount(for package: Package) -> String? {
        switch package.identifier {
        case "$rc_monthly": return ""
        case "$rc_three_month": return "Save 15%"
        case "$rc_annual": return "Save 50%"
        default: return ""
        }
    }
    
    private func calculateSubprice(for package: Package) -> String? {
        if let price = cleanAndConvertToDouble(package.localizedPriceString) {
            let roundedPrice = (price * 100).rounded() / 100
            switch package.identifier {
            case "$rc_monthly": return "$\(((roundedPrice / 1) * 100).rounded() / 100) / month"
            case "$rc_three_month": return "$\(((roundedPrice / 3) * 100).rounded() / 100) / month"
            case "$rc_annual": return "$\(((roundedPrice / 12) * 100).rounded() / 100) / month"
            default: return "$.. / mo"
            }
        }
        
        return ""
    }
    
    private func cleanAndConvertToDouble(_ priceString: String) -> Double? {
        let cleanedString = priceString.unicodeScalars.filter {
            CharacterSet.decimalDigits.union(CharacterSet.punctuationCharacters).contains($0)
        }.map { String($0) }.joined()
        
        return Double(cleanedString)
    }
}

extension SubscriptionPeriod {
    var periodTitle: String {
        switch self.unit {
        case .month:
            return value == 1 ? "1 month" : "\(value) months"
        case .year:
            return value == 1 ? "1 year" : "\(value) years"
        default:
            return "\(value) \(unit)"
        }
    }
}

//#Preview {
//    UpgradeAccountPaywallWithoutFreeTrial()
//}
