//
//  PurchaseHistory.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/20/25.
//

import SwiftUI

struct PurchaseHistory: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {

                Text("Purchase History")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                if let user = userController.user, let accountType = user.accountType {
                    if accountType == 1 {
                        // name
                        HStack {
                            // icon
                            Image(systemName: "wallet.pass")
                            
                            // text
                           
                            Text("Pro Account Purchase - 01/20/2025")
                                .font(.system(size: 14, design: .serif))
                            
                            
                            
                            Spacer()
                            
                        }
                        
                        Divider()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PurchaseHistory()
}
