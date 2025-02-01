////
////  Notifications.swift
////  Lectures
////
////  Created by Ben Dreyer on 1/20/25.
////
//
//import SwiftUI
//
//struct Notifications: View {
//    @EnvironmentObject var userController: UserController
//    @EnvironmentObject var subscriptionController: SubscriptionController
//    
//    @State var areNotificationsEnabled: Bool = true
//    @State var isUpgradeSheetShowing: Bool = false
//    var body: some View {
//        VStack {
//            ScrollView(showsIndicators: false) {
//                Text("Notifications")
//                    .font(.system(size: 15, design: .serif))
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .bold()
//                    .padding(.bottom, 10)
//                
//                if let user = userController.user, let accountType = user.accountType {
//                    if accountType == 0 {
//                        // name
//                        HStack {
//                            // icon
//                            Image(systemName: "bell")
//                            
//                            // text
//                            
//                            Text("Upgrade to customize notifications")
//                                .font(.system(size: 14, design: .serif))
//                            
//                            
//                            
//                            Spacer()
//                            
//                            // edit button
//                            Button(action: {
//                                isUpgradeSheetShowing = true
//                            }) {
//                                Text("Upgrade")
//                                    .foregroundColor(.white)
//                                    .padding(5)
//                                    .background(Color.orange)
//                                    .cornerRadius(5)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            
//                        }
//                        
//                        Divider()
//                    } else {
//                        HStack {
//                            // icon
//                            Image(systemName: "bell")
//                            
//                            // text
//                            
//                            Text("Enable Notifications")
//                                .font(.system(size: 14, design: .serif))
//                            
//                            
//                            
//                            Spacer()
//                            Toggle("", isOn: $areNotificationsEnabled)
//                                .padding(.trailing, 5)
//                        }
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 20)
//        .sheet(isPresented: $isUpgradeSheetShowing) {
//            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeSheetShowing)
//        }
//    }
//}
//
//#Preview {
//    Notifications()
//}
