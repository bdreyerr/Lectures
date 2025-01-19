//
//  HomeController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/1/25.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage
import Foundation

class HomeController : ObservableObject {
    
    // Content for the home page
    @Published var leadingUniversities: [Channel] = []
    @Published var curatedCourses: [Course] = []
    @Published var communityFavorites: [Course] = []
    // loading vars for the home page content
    @Published var isUniversityLoading: Bool = false
    @Published var isCuratedCoursesLoading: Bool = false
    @Published var isCommunityFavoritesLoading: Bool = false
    
    @Published var focusedCollection: Collection?
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    
    func retrieveLeadingUniversities(courseController: CourseController) {
        // IDs = [MIT, Harvard, Yale, something , oxford?]
        let channelIds = ["1", "2", "3", "4", "5"]
        
        Task { @MainActor in
            
            for channelId in channelIds {
                let docRef = db.collection("channels").document(channelId)
                
                do {
                    let channel = try await docRef.getDocument(as: Channel.self)
                    // Add the channel to leading university list to be displayed on home page
                    self.leadingUniversities.append(channel)
                    
                    // cache the fetched channel for future lookups
                    courseController.cachedChannels[channelId] = channel
                    
                    // TODO: add some logic to not duplicate calls
                    // get the thumbnail for the channels
                    courseController.getChannelThumbnail(channelId: channelId)
                    
                } catch {
                    print("Error decoding channel: \(error)")
                }
            }
            
            self.isUniversityLoading = false
        }
    }
    
    func retrieveCuratedCourses(courseController: CourseController) {
        // TODO: make this list curated, not just the top from the db
        Task { @MainActor in
            do {
                let querySnapshot = try await db.collection("courses").order(by: "aggregateViews", descending: true).limit(to: 5).getDocuments()
                
                if querySnapshot.isEmpty {
                    print("no courses returned when looking up community favorites")
                    return
                }
                
                for document in querySnapshot.documents {
                    if let course = try? document.data(as: Course.self) {
                        self.curatedCourses.append(course)
                        
                        // add the course to the cache
                        courseController.cachedCourses[course.id!] = course
                        
                        // TODO: add some logic to avoid making duplicate calls
                        // fetch the courses thumbnail
                        courseController.getCourseThumbnail(courseId: course.id!)
                        
                        // fetch the channel
                        courseController.retrieveChannel(channelId: course.channelId!)
                    }
                }
                
                self.isCuratedCoursesLoading = false
            } catch let error {
                print("error getting community favorites from firestore: ", error)
            }
        }
    }
    
    func retrieveCommunityFavorites(courseController: CourseController) {
        
        // get the courses with the most likes from the courses column in Firebase
        self.communityFavorites = []
        
        Task { @MainActor in
            do {
                let querySnapshot = try await db.collection("courses").order(by: "numLikesInApp", descending: true).limit(to: 5).getDocuments()
                
                if querySnapshot.isEmpty {
                    print("no courses returned when looking up community favorites")
                    return
                }
                
                for document in querySnapshot.documents {
                    if let course = try? document.data(as: Course.self) {
                        
                        self.communityFavorites.append(course)
                        
                        // add the course to the cache
                        courseController.cachedCourses[course.id!] = course
                        
                        // fetch the courses thumbnail
                        courseController.getCourseThumbnail(courseId: course.id!)
                        
                        // fetch the channel
                        courseController.retrieveChannel(channelId: course.channelId!)
                    }
                }
                
                self.isCommunityFavoritesLoading = false
            } catch let error {
                print("error getting community favorites from firestore: ", error)
            }
        }
    }
    
    func focusCollection(_ collection: Collection) {
        print("collection getting focused")
        self.focusedCollection = nil
        self.focusedCollection = collection
    }
}
