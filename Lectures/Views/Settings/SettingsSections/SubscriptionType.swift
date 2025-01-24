//
//  SubscriptionType.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/20/25.
//

import SwiftUI

struct SubscriptionType: View {
    @EnvironmentObject var userController: UserController
    
    @State var isUpgradeSheetShowing: Bool = false
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("Subscription Type")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                if let user = userController.user, let accountType = user.accountType {
                    if accountType == 0 {
                        // name
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
                }
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isUpgradeSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial()
        }
    }
}

#Preview {
    SubscriptionType()
}
