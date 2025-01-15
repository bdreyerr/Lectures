//
//  UpgradeAccountPaywallWithoutFreeTrial.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/14/25.
//

import SwiftUI

struct UpgradeAccountPaywallWithoutFreeTrial: View {
    @State private var selectedPlan: String = "3 months" // Default selected plan
    
    @State private var showProFeaturesSheet: Bool = false
    
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
                            price: "$12.90",
                            subPrice: "$4.33 per month",
                            isSelected: selectedPlan == "3 months"
                        ) {
                            selectedPlan = "3 months"
                        }
                        SubscriptionPlanView(
                            title: "12 months",
                            price: "$34.99",
                            subPrice: "$2.91 per month",
                            discount: "Save 50%",
                            isSelected: selectedPlan == "12 months"
                        ) {
                            selectedPlan = "12 months"
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Upgrade account
                    Button(action: {
                        // TODO: help the user upgrade account
                        
                    }) {
                        Text("Upgrade your account")
                            .font(.system(size: 16, design: .serif))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
                    
                    
                    Text("TODO add details $5.99 a month")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                    
                }
                .foregroundColor(.white)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    UpgradeAccountPaywallWithoutFreeTrial()
}
