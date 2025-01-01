//
//  HomeController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/1/25.
//

import Firebase
import FirebaseFirestore
import Foundation

class HomeController : ObservableObject {
    
    @Published var focusedCourse: Course?
    @Published var focusedLecture: Course?
    
    @Published var curatedCourses: [Course] = []
    @Published var communityFavorites: [Course] = []
    
    
    // Firestore
    let db = Firestore.firestore()
    
    
    init() {
        print("init in home controller")
        
        // load the lectures and courses on the homepage
        retrieveCommunityFavorites()
    }
    
    
    func retrieveCuratedCourses() {
        // TODO: make this list curated, not just the top from the db
        Task {
            do {
                let querySnapshot = try await db.collection("courses").order(by: "aggregateViews", descending: true).limit(to: 5).getDocuments()
                DispatchQueue.main.async {
                    if querySnapshot.isEmpty {
                        print("no courses returned when looking up community favorites")
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        if let course = try? document.data(as: Course.self) {
                            DispatchQueue.main.async {
                                self.curatedCourses.append(course)
                                
                                print("adding a course to the array")
                            }
                        }
                    }
                }
            } catch let error {
                print("error getting community favorites from firestore: ", error)
            }
        }
    }
    
    func retrieveCommunityFavorites() {
        // get the courses with the most likes from the courses column in Firebase
        self.communityFavorites = []
        
        
        // cache
        
        Task {
            do {
                let querySnapshot = try await db.collection("courses").order(by: "numLikesInApp", descending: true).limit(to: 5).getDocuments()
                DispatchQueue.main.async {
                    if querySnapshot.isEmpty {
                        print("no courses returned when looking up community favorites")
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        if let course = try? document.data(as: Course.self) {
                            DispatchQueue.main.async {
                                self.communityFavorites.append(course)
                                
                                print("adding a course to the array")
                            }
                        }
                    }
                }
            } catch let error {
                print("error getting community favorites from firestore: ", error)
            }
        }
    }
    
    func focusCourse(course: Course) {
        self.focusedCourse = nil
        self.focusedCourse = course
    }
}
