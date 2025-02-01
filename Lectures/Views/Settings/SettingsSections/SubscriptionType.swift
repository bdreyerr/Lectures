//
//  SubscriptionType.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/20/25.
//

import SwiftUI

struct SubscriptionType: View {
    @EnvironmentObject var userController: UserController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @State var isUpgradeSheetShowing: Bool = false
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("Subscription Type")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                
                if !subscriptionController.isPro {
                    HStack {
                        // icon
                        Image(systemName: "wallet.pass")
                        
                        // text
                        
                        Text("Free Account")
                            .font(.system(size: 14, design: .serif))
                        
                        
                        
                        Spacer()
                        
                        // edit button
                        Button(action: {
                            isUpgradeSheetShowing = true
                        }) {
                            Text("Upgrade")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.orange)
                                .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    
                    Divider()
                } else {
                    HStack {
                        // icon
                        Image(systemName: "wallet.pass")
                        
                        // text
                        
                        Text("Pro Account")
                            .font(.system(size: 14, design: .serif))
                            .foregroundStyle(Color.orange)
                            .bold()
                        
                        
                        Spacer()
                        
                    }
                    Divider()
                }
                
                // Restore Purchase
                HStack {
                    // icon
                    Image(systemName: "arrow.uturn.forward")
                    
                    // text
                    
                    Button(action: {
                        Task {
                            await subscriptionController.restorePurchases()
                        }
                    }) {
                        Text("Restore Purchases")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.blue)
                            .cornerRadius(5)
                    
                    Spacer()
                    
                    
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 2)
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isUpgradeSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeSheetShowing)
        }
    }
}

#Preview {
    SubscriptionType()
}
