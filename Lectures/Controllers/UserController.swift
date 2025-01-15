//
//  UserController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/1/25.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation

class UserController : ObservableObject {
    // User object - used to reference user throughout the app (signed in only)
    @Published var user: User?
    
    // Firestore
    let db = Firestore.firestore()
    
    init() {
        // Retrieve the user on init if auth'd
        if let userId = Auth.auth().currentUser?.uid {
            self.retrieveUserFromFirestore(userId: userId)
        } else {
            print("auth wasn't setup yet.")
        }
    }
    
    func retrieveUserFromFirestore(userId: String) {
        self.user = nil
        let docRef = db.collection("users").document(userId)
        docRef.getDocument(as: User.self) { result in
            switch result {
            case .success(let userObject):
                self.user = userObject
                print("we have the user: ", self.user?.email ?? "no email")
            case .failure(let error):
                print("Failure retrieving user from firestore: ", error.localizedDescription)
            }
        }
    }
    
    func logOut() {
        self.user = nil
        print("log out - local user")
    }
    
    func deleteUser() {
        // Delete the current user in firestore (not auth)
        Task {
            if let user = self.user {
                do {
                    try await db.collection("users").document(user.id!).delete()
                    print("Document successfully removed!")
                    DispatchQueue.main.async {
                        self.logOut()
                    }
                    
                } catch {
                    print("Error removing document: \(error)")
                }
            } else {
                print("no user and we can't delete it")
            }
        }
    }
    
    func changeMebershipType(userId: String, freeToPro: Bool) {
        // if freetoPro is true, change membership type from 0 to 1, else from 1 to 0
        
        Task { @MainActor in
            let userRef = db.collection("users").document(userId)

            // Set the "capital" field of the city 'DC'
            do {
              try await userRef.updateData([
                "accountType": freeToPro ? 1 : 0
              ])
              print("Document successfully updated")
            } catch {
              print("Error updating document: \(error)")
            }
        }
    }
    
}
