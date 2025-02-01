//
//  AuthController.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/31/24.
//
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
//import FirebaseFirestoreSwift
import Foundation
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

class AuthController : UIViewController, ObservableObject {
    // Controls which views the user can access based on login status.
    @AppStorage("isSignedIn") private var isSignedIn = false
    // Whether or not the user still sess the paywall screen after app first start
    @AppStorage("hasUserSeenPaywall") private var hasUserSeenPaywall = false
    
//    @Published var selectedMembershipType: Int = 0
    
    @Published var email = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    // Unhashed nonce. (used for Apple sign in)
    @Published var currentNonce: String?
    @Published var request: ASAuthorizationAppleIDRequest?
    
    @Published var errorString: String = ""
    @Published var isErrorStringShowing: Bool = false
    
    @Published var isFinishedSigningIn: Bool = false
    
    let db = Firestore.firestore()
    
    @available(iOS 13, *)
    // The function called in the onComplete closure of the SignInWithAppleButton in the RegisterView
    func appleSignInButtonOnCompletion(result: Result<ASAuthorization, Error>, displaySignInSheet: Binding<Bool>) {
        switch result {
        case .success(let authResults):
            print("GETTING RESULT IN ON SIGN IN BUTTON COMPLETEION")
            
            
            print(authResults.credential.description)
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                
                print("full name: ", appleIDCredential.fullName ?? "no name")
                print("email: ", appleIDCredential.email ?? "no email")
                
                
                if let email = appleIDCredential.email {
                    print(" we have the email it's here: ", email)
                } else {
                    print("we don't have an email:")
                }
                if let fullName = appleIDCredential.fullName {
                    if let firstName = fullName.givenName {
                        self.firstName = firstName
                    }
                    
                    if let lastName = fullName.familyName {
                        self.lastName = lastName
                    }
                }
                
                if self.firstName == "" {
                    self.firstName = "Guest"
                }
                
                if self.lastName == "" {
                    self.lastName = "Writer"
                }
                
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                
                //                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString, rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    guard let user = authResult?.user else {
                        print("No user")
                        return
                    }
                    
                    // grab the email
                    if let email = user.email {
                        self.email = email
                    }
                    
                    print("signed in with apple")
                    print("\(String(describing: user.uid))")
                    
                    // Figure out if the user already has an account and is signing in
                    // or if this is their first time signing up. (check on email)
                    let docRef = self.db.collection("users").whereField("email", isEqualTo: self.email)
                    docRef.getDocuments { (querySnapshot, err) in
                        if let err = err {
                            print(err.localizedDescription)
                        } else {
                            if let querySnapshot = querySnapshot {
                                if querySnapshot.documents.isEmpty {
                                    // User doesn't exist in the database yet, create a new user object
                                    
                                    // The only field not populated is profilePicture. User needs to add that themselves.
                                    let userObject = User(firstName: self.firstName, lastName: self.lastName, email: self.email, accountType: 0, likedCourseIds: [], likedLectureIds: [], followedChannelIds: [], isAdmin: false)
                                    
                                    // Add the user to firestore user collection
                                    let collectionRef = self.db.collection("users")
                                    do {
                                        try collectionRef.document(user.uid).setData(from: userObject)
                                        self.isSignedIn = true
                                        
                                        
                                        self.isFinishedSigningIn = true
                                        
                                        print("a new user signed in")
                                        
                                        // close the sign in sheet when sign in finishes, if a
                                        if displaySignInSheet.wrappedValue {
                                            displaySignInSheet.wrappedValue = false
                                        }
                                    } catch {
                                        print("Error saving the new user to firestore")
                                    }
                                } else {
                                    // An existing user is signing back in
                                    if let user = Auth.auth().currentUser {
                                        print("current user signed in ", user.uid)
                                    }
                                    self.isSignedIn = true
                                    // Set user defaults
                                    //                                UserDefaults.standard.set(self.isSignedIn, forKey: loginStatusKey)
                                    self.isFinishedSigningIn = true
                                    
                                    print("an existing user signed in")
                                    
                                    
                                    // make it so the paywall goes away -
//                                    self.hasUserSeenPaywall = true
                                }
                            }
                        }
                    }
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    func signInWithGoogle(displaySignInSheet: Binding<Bool>) {
        // get app client id
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In config object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        // sign in mrthod goes here
        
        GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) { user, error in
            if let error = error {
                print(error)
                return
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let user = result?.user else { return }
                print("user was signed in: ", user)
                print(user.displayName ?? "display name")
                print(user.email ?? "email")
                
                // Split the display name into a first and last name, there's a space inbetween, usually
                let names = user.displayName?.components(separatedBy: " ")
                
                if let names = names {
                    if names.count >= 2 {
                        let firstName = names[0]
                        let lastName = names[1]
                        self.firstName = firstName
                        self.lastName = lastName
                    } else {
                        //                        print("The string does not contain a space")
                        self.firstName = user.displayName ?? ""
                        self.lastName = ""
                    }
                } else {
                    self.firstName = user.displayName ?? ""
                    self.lastName = ""
                }
                
                self.email = user.email ?? ""
                
                // Figure out if the user already has an account and is signing in
                // or if this is their first time signing up. (check on email)
                let docRef = self.db.collection("users").whereField("email", isEqualTo: self.email)
                docRef.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print(err.localizedDescription)
                    } else {
                        if let querySnapshot = querySnapshot {
                            if querySnapshot.documents.isEmpty {
                                // User doesn't exist in the database yet, create a new user object
                                
                                let userObject = User(firstName: self.firstName, lastName: self.lastName, email: self.email, accountType: 0, likedCourseIds: [], likedLectureIds: [], followedChannelIds: [], isAdmin: false)
                                
                                // Add the user to firestore user collection
                                let collectionRef = self.db.collection("users")
                                do {
                                    try collectionRef.document(user.uid).setData(from: userObject)
                                    self.isSignedIn = true
                                    
                                    self.isFinishedSigningIn = true
                                    
                                    // close the sign in sheet when sign in finishes, if a
                                    if displaySignInSheet.wrappedValue {
                                        displaySignInSheet.wrappedValue = false
                                    }
                                    
                                } catch {
                                    print("Error saving the new user to firestore")
                                }
                            } else {
                                // An existing user is signing back in
                                if let user = Auth.auth().currentUser {
                                    print("current user signed in ", user.uid)
                                }
                                self.isSignedIn = true
                                
                                self.isFinishedSigningIn = true
                                
                                // make it so the paywall goes away -
//                                self.hasUserSeenPaywall = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            return
        }
        self.isSignedIn = false
        self.hasUserSeenPaywall = false
        print("The user logged out")
    }
    
    func deleteAuthUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("error deleting auth account: ", error)
            } else {
                // Account deleted.
                //              print("auth accound deleted successfully")
                self.logOut()
            }
        }
    }
    
    // Functions for apple sign in flow
    
    // Generate a random Nonce used to make sure the ID token you get was granted specifically in response to your app's authentication request.
    // Hashing function using CryptoKit
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // from https://firebase.google.com/docs/auth/ios/apple
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
}

extension AuthController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            print("SOMETHING HAPPENNING NOE?? - IN EXTENSION")
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a fresh Apple credential with Firebase.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription as Any)
                    return
                }
                
                guard let user = authResult?.user else {
                    //                        print("No user")
                    return
                }
                
                // grab the email
                if let email = user.email {
                    self.email = email
                }
                
                
                if let name = user.displayName {
                    print("display name is: ", name)
                } else {
                    print("no display name")
                }
            }
        default:
            break
        }
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print(error)
    }
}

extension AuthController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension UIViewController {
    func showLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as? AuthController {
            loginViewController.modalPresentationStyle = .formSheet
            loginViewController.isModalInPresentation = true
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
