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
        Task { @MainActor in
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
    }
    
    func logOut() {
        self.user = nil
        print("log out - local user")
    }
    
    func deleteUser() {
        // Delete the current user in firestore (not auth)
        Task { @MainActor in
            if let user = self.user, let id = user.id {
                do {
                    try await db.collection("users").document(id).delete()
                    
                    self.logOut()
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
            
            userRef.updateData([
                "accountType": freeToPro ? 1 : 0
            ])
            print("Document successfully updated")
            
        }
    }
    
    func followChannel(userId: String, channelId: String) {
        Task { @MainActor in
            
            var follow: Bool = false
            
            // figure out if following or unfollowing
            if let user = self.user, let followedChannelIds = user.followedChannelIds {
                if followedChannelIds.contains(channelId) {
                    follow = false
                    if let _ = self.user {
                        self.user?.followedChannelIds?.removeAll(where: {$0 == channelId})
                    }
                } else {
                    follow = true
                    // also update local user var
                    if let _ = self.user {
                        self.user?.followedChannelIds?.append(channelId)
                    }
                }
            }
            
            let userRef = db.collection("users").document(userId)
            
            if follow {
                userRef.updateData([
                    "followedChannelIds": FieldValue.arrayUnion([channelId])
                ])
                
            } else {
                userRef.updateData([
                    "followedChannelIds": FieldValue.arrayRemove([channelId])
                ])
            }
        }
    }
    
    func likeCourse(userId: String, courseId: String) {
        Task { @MainActor in
            // determine if we are liking or unliking this course
            var isLiking: Bool = false
            
            if let user = self.user, let likedCourseIds = user.likedCourseIds {
                if likedCourseIds.contains(courseId) {
                    isLiking = false
                    if let _ = self.user {
                        self.user?.likedCourseIds?.removeAll(where: {$0 == courseId})
                    }
                } else {
                    isLiking = true
                    // also update local user var
                    if let _ = self.user {
                        self.user?.likedCourseIds?.append(courseId)
                    }
                }
            }
            
            let userRef = db.collection("users").document(userId)
            
            if isLiking {
                userRef.updateData([
                    "likedCourseIds": FieldValue.arrayUnion([courseId])
                ])
                
            } else {
                userRef.updateData([
                    "likedCourseIds": FieldValue.arrayRemove([courseId])
                ])
            }
            
        }
    }
    
    func likeLecture(userId: String, lectureId: String) {
        Task { @MainActor in
            // determine if we are liking or unliking this course
            var isLiking: Bool = false
            
            if let user = self.user, let likedLectureIds = user.likedLectureIds {
                if likedLectureIds.contains(lectureId) {
                    isLiking = false
                    if let _ = self.user {
                        self.user?.likedLectureIds?.removeAll(where: {$0 == lectureId})
                    }
                } else {
                    isLiking = true
                    // also update local user var
                    if let _ = self.user {
                        self.user?.likedLectureIds?.append(lectureId)
                    }
                }
            }
            
            let userRef = db.collection("users").document(userId)
            
            if isLiking {
                userRef.updateData([
                    "likedLectureIds": FieldValue.arrayUnion([lectureId])
                ])
                
            } else {
                userRef.updateData([
                    "likedLectureIds": FieldValue.arrayRemove([lectureId])
                ])
            }
        }
    }
    
    func changeName(firstName: String, lastName: String) {
        Task { @MainActor in
            // change the name in firestore
            if let user = self.user, let id = user.id {
                let userRef = db.collection("users").document(id)

                // Set the "capital" field of the city 'DC'
                do {
                  try await userRef.updateData([
                    "firstName": firstName,
                    "lastName": lastName,
                  ])
                    
                    // update it locally
                    self.user?.firstName = firstName
                    self.user?.lastName = lastName
                  
                } catch {
                }
            }
            
        }
    }
}
