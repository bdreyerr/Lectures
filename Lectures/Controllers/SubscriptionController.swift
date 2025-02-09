//
//  SubscriptionController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/31/25.
//


import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation
import RevenueCat
import SwiftUI

class SubscriptionController: NSObject, ObservableObject {
    @Published var packages: [Package] = []
    @Published var customerInfo: CustomerInfo?
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isPro: Bool = false
    
//    @EnvironmentObject var userController: UserController
    
    // Singleton instance
    static let shared = SubscriptionController()
    
    // Firestore
    let db = Firestore.firestore()
    
    private override init() {
        super.init() // Required when inheriting from NSObject
        // Fetch initial data
        Task {
            await fetchPackages()
            await updateCustomerInfo()
        }
    }
    
    @MainActor
    func fetchPackages() async {
        isLoading = true
        error = nil
        
        do {
            // Fetch offering
            let offering = try await Purchases.shared.offerings().current
            
            if let availablePackages = offering?.availablePackages {
                self.packages = availablePackages
            } else {
                error = "No packages available"
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func updateCustomerInfo() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            self.customerInfo = customerInfo
            
            // Check if user has pro access
            isPro = customerInfo.entitlements["Lectura Pro"]?.isActive == true
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    @MainActor
    func purchase(package: Package) async -> Bool {
        isLoading = true
        error = nil
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            customerInfo = result.customerInfo
            isPro = result.customerInfo.entitlements["Lectura Pro"]?.isActive == true
            isLoading = false
            
            // if purchase is successfull, change the account type on the user
            changeUserMembershipTypeInFirestore(freeToPro: isPro)
            return true
        } catch {
            self.error = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func restorePurchases() async {
        isLoading = true
        error = nil
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            await MainActor.run {
                self.customerInfo = customerInfo
                self.isPro = customerInfo.entitlements["Lectura Pro"]?.isActive == true
                
                // if purchase is successfull, change the account type on the user
                changeUserMembershipTypeInFirestore(freeToPro: isPro)
            }
        } catch {
            await MainActor.run {
                self.error = error.localizedDescription
            }
        }
        
        await MainActor.run {
            self.isLoading = false
        }
    }

    func loginRevenueCat(userId: String) {
        Task {
            Purchases.shared.logIn(userId) { (customerInfo, created, error) in
                if let customerInfo = customerInfo {
                    // customerInfo updated for my_app_user_id
                    self.customerInfo = customerInfo

                    // Check if user has pro access
                    self.isPro = customerInfo.entitlements["Lectura Pro"]?.isActive == true
                }
            }
        }
    }
    
    func logOutRevenueCat() {
        Purchases.shared.logOut { customerInfo ,_ in
            if let customerInfo = customerInfo {
                self.customerInfo = customerInfo
            }
        }
        
        self.isPro = false
    }
    
    func changeUserMembershipTypeInFirestore(freeToPro: Bool) {
        // get the firebase auth user id
        if let currentUser = Auth.auth().currentUser {
            // write to firestore
            
            Task { @MainActor in
                let userRef = db.collection("users").document(currentUser.uid)
                
                userRef.updateData([
                    "accountType": freeToPro ? 1 : 0
                ])
                print("Document successfully updated")
            }
        }
    }
}

// MARK: - PurchasesDelegate
extension SubscriptionController: PurchasesDelegate {
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
            self.isPro = customerInfo.entitlements["Lectura Pro"]?.isActive == true
            
            changeUserMembershipTypeInFirestore(freeToPro: isPro)
        }
    }
}
