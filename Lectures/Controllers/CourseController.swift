//
//  CourseController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/15/25.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import SwiftUI

// This controller is used for handling all instances of courses, lectures, and channels. If any of those objects need to be loaded or displayed in the app, the logic will happen here
class CourseController : ObservableObject {
    
    // ---------- Caches ----------
    // CourseId : Course
    @Published var cachedCourses: [String : Course] = [:]
    // LectureId : Course
    @Published var cachedLectures: [String : Lecture] = [:]
    // ChannelId: Channel
    @Published var cachedChannels: [String : Channel] = [:]
    // CourseId : [Lecture]
    @Published var lecturesInCourse: [String : [Lecture]] = [:]
    // CourseId : [Lecture]
    @Published var lecturesInSameCourse: [String : [Lecture]] = [:]
    // CourseId: [Course]
    @Published var cachedCourseRecommendations: [String : [Course]] = [:]
    // Course Views [CourseId : Bool]
    private var cachedCourseViews: [String : Bool] = [:]
    // Lecture Views [LectureId : Bool]
    private var cachedLectureViews: [String : Bool] = [:]
    
    // ---------- Focus ----------
    // Course Recommendations for currently focused course
    @Published var courseRecommendations: [Course] = []
    
    // ---------- Pagination ----------
    // For Focused Channel, we paginate the courses under this channel, this var tracks pagination (we order it in increments of 10)
    @Published var channelCoursesPrefixPaginationNumber: Int = 10
    // For Lectures In Course, we paginate how many lectures show up
    @Published var lecturesInCoursePrefixPaginationNumber: Int = 8
    
    
    // ---------- Thumbnails ----------
    // CourseId : UIImage
    @Published var courseThumbnails: [String : UIImage] = [:]
    // LectureId : UIImage
    @Published var lectureThumbnails: [String : UIImage] = [:]
    // ChannelId : UIImage
    @Published var channelThumbnails: [String : UIImage] = [:]
    
    // Thumbnail Request Queue
    // CourseId : IsRequestProcessingOrFinished
    @Published var courseThumbnailRequestQueue: [String : Bool] = [:]
    // LectureId : IsRequestProcessingOrFinished
    @Published var lectureThumbnailRequestQueue: [String : Bool] = [:]
    // ChannelId : IsRequestProcessingOrFinished
    @Published var channelThumbnailRequestQueue: [String : Bool] = [:]
    
    // Loading vars
    @Published var isRelatedCourseLoading: Bool = false
    @Published var isLecturesInCourseLoading: Bool = false
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    // Each home page will store it's list of courses / channels individually, but they will retrieve them through this controller, checking the cache before making a lookup
    
    // ---------- FUNCTIONS ----------
    

    
    // ---------- Retrieval ----------
    func retrieveCourse(courseId: String) {
//        print("fetching course from course controller")
        
        // check the cache
        if let _ = cachedCourses[courseId] {
            //            print("course already cached")
            return
        }
        
        Task { @MainActor in
            let docRef = db.collection("courses").document(courseId)
            
            do {
                var course = try await docRef.getDocument(as: Course.self)
                
                // sort the courses lecture Id list
                if let lectures = course.lectureIds {
                   course.lectureIds = lectures.sorted { lhs, rhs in
                        // Get lecture numbers from the IDs (assuming format includes number at the end)
                        let lhsNumber = Int(lhs.components(separatedBy: "_").last ?? "0") ?? 0
                        let rhsNumber = Int(rhs.components(separatedBy: "_").last ?? "0") ?? 0
                        return lhsNumber < rhsNumber
                    }
                }
                self.cachedCourses[courseId] = course
                
                // don't fetch the thumbnail, we only need to see it if user wants to access a specific course or lecture
            } catch {
                print("Error decoding course: \(error)")
            }
        }
    }
    
    func retrieveChannel(channelId: String) {
        // check the cache
        if let _ = cachedChannels[channelId] {
            //            print("channel already cached")
            return
        }
        
        Task { @MainActor in
            let docRef = db.collection("channels").document(channelId)
            
            do {
                let channel = try await docRef.getDocument(as: Channel.self)
                self.cachedChannels[channelId] = channel
                
                // don't fetch the thumbnail, we only need to see it if user wants to access a specific course or lecture
            } catch {
                print("channel decoding error: \(channelId)")
                print("Error decoding channel: \(error)")
            }
        }
    }
    
    func retrieveLecture(lectureId: String) {
        // check the cache
        if let _ = cachedLectures[lectureId] {
            //            print("channel already cached")
            return
        }
        
        Task { @MainActor in
            let docRef = db.collection("lectures").document(lectureId)
            
            do {
                let lecture = try await docRef.getDocument(as: Lecture.self)
                self.cachedLectures[lectureId] = lecture
                
                // don't fetch the thumbnail, we only need to see it if user wants to access a specific course or lecture
            } catch {
                print("Error decoding channel: \(error)")
            }
        }
    }
    
    
    // Paginate lectures in course by only calling groups of 8 lectures at a time. If the user has already watched this course, focus the last watched lecture at the middle of the group of 8, allowing for user to then recall this function with the previous 8 or next 8. If the user hasn't watched this course before, just load the first 8. This is controlled by which lectureIds are passed in as arguemnts.
    func retrieveLecturesInCourse(courseId: String, lectureIdsToLoad: [String]) {
        var newLectures: [Lecture] = []
        
        isLecturesInCourseLoading = true
        Task { @MainActor in
            for lectureId in lectureIdsToLoad {
                // check cache
                if let lecture = cachedLectures[lectureId] {
                    newLectures.append(lecture)
                    continue
                }
                
                // otherwise fetch it from firestore and store it in the cache
                let docRef = db.collection("lectures").document(lectureId)
                
                do {
                    let lecture = try await docRef.getDocument(as: Lecture.self)
                    
                    newLectures.append(lecture)
                    
                    // add the newly fetched lecture to the cache
                    self.cachedLectures[lectureId] = lecture
                    
                    // fetch the lecture thumbnail from storage
                    self.getLectureThumnbnail(lectureId: lectureId)
                    
                    // fetch the channel
                    if let lectureChannelId = lecture.channelId {
                        self.retrieveChannel(channelId: lectureChannelId)
                    }
                } catch {
                    print("Error decoding lecture: \(error)")
                }
                
                // check if this course already has lectures loaded, if it does, add these new ones
                if let existingLectures = self.lecturesInCourse[courseId] {
                    var totalLectures = (existingLectures + newLectures)
                    // sort totalLectures
                    self.lecturesInCourse[courseId] = totalLectures
                } else {
                    self.lecturesInCourse[courseId] = newLectures
                }
            }
            isLecturesInCourseLoading = false
        }
    }
    
    // ---------- Generation & Content Recommendation ----------
    func generateRecommendedCourses(courseId: String, searchTerms: [String]) {
        self.isRelatedCourseLoading = true
        
        // Validate input
        guard !searchTerms.isEmpty else {
            print("Search terms array is empty")
            self.courseRecommendations = []
            self.isRelatedCourseLoading = false
            return
        }
        
        // Check cache
        if let courseRecs = self.cachedCourseRecommendations[courseId] {
            self.courseRecommendations = courseRecs
            self.isRelatedCourseLoading = false
            return
        }
        
        Task { @MainActor in
            do {
                let coursesRef = db.collection("courses")
                
                let query = coursesRef
                    .whereField(FieldPath.documentID(), isNotEqualTo: courseId)
                    .whereField("searchTerms", arrayContainsAny: searchTerms)
                    .limit(to: 3)
                
                let querySnapshot = try await query.getDocuments()
                
//                print("Found \(querySnapshot.documents.count) matching documents")
                
                let recommendedCourses = querySnapshot.documents.compactMap { document in
                    if let course = try? document.data(as: Course.self) {
                        if let courseId = course.id {
                            self.getCourseThumbnail(courseId: courseId)
                        }
                        
                        // fetch channel so it can show up in the related course card
                        if let channelId = course.channelId {
                            self.retrieveChannel(channelId: channelId)
                        }
                        return course
                    }
                    return nil
                }
                
                await MainActor.run {
                    self.courseRecommendations = recommendedCourses
                    self.cachedCourseRecommendations[courseId] = recommendedCourses
                    self.isRelatedCourseLoading = false
                }
            } catch {
                print("Error fetching recommended courses: \(error.localizedDescription)")
                await MainActor.run {
                    self.courseRecommendations = []
                    self.isRelatedCourseLoading = false
                }
            }
        }
    }
    
    
    // ---------- Focus Functions ----------
    func focusCourse(_ course: Course) {
        if let channelId = course.channelId {
            
            // TODO: add some logic to avoid duplicate calls to storage
            // When a course gets focused we want to make sure the channel's thumbnail is loaded and ready to display on Courseview
            self.getChannelThumbnail(channelId: channelId)
            
            // generate related courses
            if let id = course.id, let searchTerms = course.searchTerms {
                self.generateRecommendedCourses(courseId: id, searchTerms: searchTerms)
            } else {
                print("couldn't generate recommended courses")
            }
            
            // set the number of lectures we paginate in this course
            self.lecturesInCoursePrefixPaginationNumber = 8
            
            // Only increment view count if this is first time viewing
            if let courseId = course.id {
                if cachedCourseViews[courseId] == nil {
                    // First time viewing this course
                    cachedCourseViews[courseId] = true
                    
                    // Increment view count in Firestore
                    let courseRef = db.collection("courses").document(courseId)
                    courseRef.updateData([
                        "numViews": FieldValue.increment(Int64(1))
                    ]) { err in
                        if let err = err {
                            print("Error updating course views: \(err)")
                        }
                    }
                }
            }
        }
    }
    
    func focusLecture(_ lecture: Lecture) {
        if let channelId = lecture.channelId {
            
            // When a lecture gets focused we want to make sure the channel's thumbnail is loaded and ready to display on LectureView
            self.getChannelThumbnail(channelId: channelId)
            
            // Only increment view count if this is first time viewing
            if let lectureId = lecture.id {
                if cachedLectureViews[lectureId] == nil {
                    // First time viewing this course
                    cachedLectureViews[lectureId] = true
                    
                    // Increment view count in Firestore
                    let courseRef = db.collection("lectures").document(lectureId)
                    courseRef.updateData([
                        "numViews": FieldValue.increment(Int64(1))
                    ]) { err in
                        if let err = err {
                            print("Error updating lecture views: \(err)")
                        }
                    }
                }
            }
        }
    }
    
    func focusChannel(_ channel: Channel) {
        if let channelId = channel.id, let courseIds = channel.courseIds {
            self.channelCoursesPrefixPaginationNumber = 10
            
            // get channel thumbnail
            self.getChannelThumbnail(channelId: channelId)
            
            // We only want to retrieve the first 10 courses by this channel.
            let coursesToRetrieve = Array(courseIds.prefix(channelCoursesPrefixPaginationNumber))
            
            for courseId in coursesToRetrieve {
                // Retrieve the course from firestore
                self.retrieveCourse(courseId: courseId)
                // Retrieve the thumbnail for the course from storage
                self.getCourseThumbnail(courseId: courseId)
            }
        }
    }
    
    // ---------- Fetch Thumbnail (Storage) ----------
    func getCourseThumbnail(courseId: String) {
        // check if request was already made for this course
        if let request = self.courseThumbnailRequestQueue[courseId] {
            // make sure it's set to true, if we failed to retrieve thumbnail, we'll set the bool val back to false
            if request {
//                print("we already requested this course thumbnail")
                return
            }
        }
        
        // first time requesting this thumbnail, process the request
        self.courseThumbnailRequestQueue[courseId] = true
        
        Task { @MainActor in
            
            // check cache
            if let _ = self.courseThumbnails[courseId] {
                //            print("course thumbnail already cached")
                return
            }
            
            // Fetch image from firestore
            
            let storage = Storage.storage()

            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            
            // Fetch the prompts image from storage
            let imageRef = storageRef.child("courses/" + courseId + ".jpeg")
            
            // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error downloading image from storage: ", error.localizedDescription)
                    // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                    
                    self.courseThumbnailRequestQueue[courseId] = false
                    return
                } else {
                    if let data = data {
                        // Data for image is returned
                        let image = UIImage(data: data)
                        // Add image to cache
                        self.courseThumbnails[courseId] = image
                    }
                }
            }
        }
    }
    
    func getLectureThumnbnail(lectureId: String) {
        // Do nothing, we don't use lecture thumbnails anymore, just the course.
    }
    
    func getChannelThumbnail(channelId: String) {
        // check if request was already made for this course
        if let request = self.channelThumbnailRequestQueue[channelId] {
            // make sure it's set to true, if we failed to retrieve thumbnail, we'll set the bool val back to false
            if request {
//                print("we already requested this channel thumbnail")
                return
            }
        } else {
            // first time requesting this thumbnail, process the request
            self.channelThumbnailRequestQueue[channelId] = true
        }
        
        // check cache
        if let _ = self.channelThumbnails[channelId] {
            //            print("channel thumbnail already cached")
            return
        }
        
        Task { @MainActor in
            // Get a reference to the storage service using the default Firebase App
            let storage = Storage.storage()

            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            // Fetch the prompts image from storage
            let imageRef = storageRef.child("channels/" + channelId + ".jpeg")
            
            // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error downloading image from storage: ", error.localizedDescription)
                    // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                    self.channelThumbnailRequestQueue[channelId] = false
                    return
                } else {
                    if let data = data {
                        // Data for image is returned
                        let image = UIImage(data: data)
                        // Add image to cache
                        self.channelThumbnails[channelId] = image
                    }
                }
            }
        }
    }

    // ---------- Misc Functions ----------
    func reportIssueWithResource(resourceType: Int, resourceId: String, issue: String) {
        Task { @MainActor in
            do {
                let issueData: [String: Any] = [
                    "resourceType": resourceType,
                    "resourceId": resourceId,
                    "issue": issue,
                    "timestamp": FieldValue.serverTimestamp()
                ]
                
                try await db.collection("resourceIssues").addDocument(data: issueData)
            } catch {
                print("Error reporting resource issue: \(error.localizedDescription)")
            }
        }
    }
}
