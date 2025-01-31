
import FirebaseAuth
import SwiftUI

struct OnboardingPaywallWithFreeTrial: View {
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var tabbarController: TabBarController
//    @EnvironmentObject var authController: AuthController
    @EnvironmentObject var userController: UserController
    
    @State private var selectedPlan: String = "3 months" // Default selected plan
    @State private var showProFeaturesSheet: Bool = false
    @State private var showSignUpSheet: Bool = false
    @State private var showSignInSheet: Bool = false
    
    var body: some View {
        ZStack {
            LatticeBackground()
            
            VStack {
                HStack {
                    Image("lectura-icon")
                        .resizable()
                        .frame(width: 35, height: 35)
        //                .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack {
                        Text("Lectura")
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.white)
                    }
                    
                    Spacer()
                    
                    // Skip button
                    Button(action: {
                        // let the user skip to the app, without creating an account
                        hasUserSeenPaywall = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Skip")
                                .font(.system(size: 16, design: .serif))
                                .opacity(0.8)
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .cornerRadius(5)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false ) {
                    // Header with logo and title
                    VStack {
                        Text("Start your learning journey with a")
                            .font(.system(size: 16, design: .serif))
                        Text("7 day free trial")
                            .font(.system(size: 22, design: .serif))
                    }
                    .padding(.top, 5)
                    
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
                    
                    Text("Choose your plan after the free trial")
                        .font(.system(size: 16, design: .serif))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                    // Subscription plans
                    VStack(spacing: 15) {
                        SubscriptionPlanView(
                            title: "1 month",
                            price: "$5.99",
                            subPrice: "$5.99 per month",
                            isSelected: selectedPlan == "1 month"
                        ) {
                            selectedPlan = "1 month"
                        }
                        SubscriptionPlanView(
                            title: "3 months",
                            price: "$14.99",
                            subPrice: "$4.99 per month",
                            discount: "Save 20%",
                            isSelected: selectedPlan == "3 months"
                        ) {
                            selectedPlan = "3 months"
                        }
                        SubscriptionPlanView(
                            title: "12 months",
                            price: "$34.99",
                            subPrice: "$2.99 per month",
                            discount: "Save 50%",
                            isSelected: selectedPlan == "12 months"
                        ) {
                            selectedPlan = "12 months"
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Start free trial button
                    Button(action: {
                        print("Selected Plan: \(selectedPlan)")
                        
                        // there's no way a user could be signed in viewing this page, there's a different view if the user is trying to upgrade after this
                        
                        // show the sign in sheet
                        if !isSignedIn {
                            showSignUpSheet = true
                        } else {
                            // for now just skip to app and write the users membership type to pro
                            
                            if let user = Auth.auth().currentUser {
                                userController.changeMebershipType(userId: user.uid, freeToPro: true)
                                userController.retrieveUserFromFirestore(userId: user.uid)
                                hasUserSeenPaywall = true
                            }
                            
                            // TODO: add the payment logic here and free trial logic
                        }
                        
                        
                    }) {
                        Text("Start free trial")
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .sheet(isPresented: $showSignUpSheet) {
                        FirstOpenSignUpSheet(text: "Create an account to start your free trial", displaySheet: $showSignUpSheet)
                            .presentationDetents([.fraction(0.4), .medium]) // User can drag between these heights
                    }
                    .padding(.top, 10)
                    
                    
                    Text("7 days for free, then $5.99 a month")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                    // Continue with free account
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
                    
                    
                    // don't let the user sign in again if they already signed in (they probably just signed in before starting free trial)
                    if !isSignedIn {
                        // already have an account
                        Button(action: {
                            showSignInSheet = true
                            //                        FirstOpenSignUpSheet(displaySheet: .constant(false))
                        }) {
                            Text("Log In with existing account")
                                .font(.system(size: 16, design: .serif))
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 30)
                        .sheet(isPresented: $showSignInSheet) {
                            FirstOpenSignUpSheet(text: "Sign in to your existing account", displaySheet: .constant(false))
                                .presentationDetents([.fraction(0.4), .medium]) // User can drag between these heights
                        }
                        .padding(.top, 10)
                    }
                    
                    //                Spacer()
                    
                    Text("You can cancel the subscription at any time from the app store at no additional cost. If you do not cancel it before the end of the current period, you will be charged.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            tabbarController.isTabbarShowing = false
        }
        .onDisappear {
            tabbarController.isTabbarShowing = true
        }
    }
}

struct SubscriptionPlanView: View {
    var title: String
    var price: String
    var subPrice: String? = nil
    var discount: String? = nil
    var isSelected: Bool
    var onTap: () -> Void // Action when the plan is tapped
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 16, design: .serif))
                if let subPrice = subPrice {
                    Text(subPrice)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(price)
                    .font(.system(size: 16, design: .serif))
                if let discount = discount {
                    Text(discount)
                        .font(.system(size: 14, design: .serif))
                        .foregroundColor(.orange)
                        .bold()
                }
            }
            .padding(.trailing, 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.orange.opacity(0.2) : Color.white.opacity(0.1))
        .animation(.easeInOut(duration: 0.4), value: isSelected) // Animate background change
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                .animation(.easeInOut(duration: 0.4), value: isSelected) // Animate border change
        )
        .onTapGesture {
            onTap() // Trigger the tap action
        }
    }
}

struct LatticeBackground: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
            GeometryReader { geometry in
                let spacing: CGFloat = 20
                let lineWidth: CGFloat = 0.5
                let rows = Int(geometry.size.height / spacing)
                let columns = Int(geometry.size.width / spacing)
                
                Path { path in
                    for row in 0...rows {
                        let y = CGFloat(row) * spacing
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    for column in 0...columns {
                        let x = CGFloat(column) * spacing
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                }
                .stroke(Color.gray.opacity(0.3), lineWidth: lineWidth)
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct ProFeaturesSheet: View {
    var body: some View {
        ZStack {
            LatticeBackground()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Lectura PRO Features")
                    .font(.system(size: 24, design: .serif))
                    .bold()
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    FeatureRow(icon: "checkmark.circle.fill", text: "Free access to all courses and lectures")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Ad-free experience.")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Personalized Learning (Course Progress, Saved Lectures, Follow Universities)")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Free access to all course and lecture resources (notes, homework, exams)")
                    FeatureRow(icon: "checkmark.circle.fill", text: "Share resources outside the app")
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea(.all)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .font(.title2)
            Text(text)
                .font(.body)
                .font(.system(size: 18, design: .serif))
        }
    }
}

#Preview {
    OnboardingPaywallWithFreeTrial()
}
