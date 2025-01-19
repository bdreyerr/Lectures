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
    
    // ---------- Focus ----------
    @Published var focusedCourse: Course?
    @Published var focusedLecture: Lecture?
    @Published var focusedChannel: Channel?
    // Focused stack (used to ensure proper lecture / course is displayed during navigation)
    @Published var focusedLectureStack: [Lecture] = []
    @Published var focusedCourseStack: [Course] = []
    
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
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    // Each home page will store it's list of courses / channels individually, but they will retrieve them through this controller, checking the cache before making a lookup
    
    // ---------- FUNCTIONS ----------
    
    // ---------- Retrieval ----------
    func retrieveCourse(courseId: String) {
        print("fetching course from course controller")
        
        // check the cache
        if let _ = cachedCourses[courseId] {
            //            print("course already cached")
            return
        }
        
        Task { @MainActor in
            let docRef = db.collection("courses").document(courseId)
            
            do {
                let course = try await docRef.getDocument(as: Course.self)
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
    
    func retrieveLecturesInCourse(courseId: String, lectureIds: [String]) {
        var lectures: [Lecture] = []
        
        Task { @MainActor in
            // reset the var
            self.lecturesInCourse[courseId] = []
            
            
            for lectureId in lectureIds {
                // check the cache before making a DB call
                if let lecture = cachedLectures[lectureId] {
                    lectures.append(lecture)
                    print("lecture already cached")
                    continue
                }
                
                // otherwise look it up in DB
                
                let docRef = db.collection("lectures").document(lectureId)
                
                do {
                    let lecture = try await docRef.getDocument(as: Lecture.self)
                    lectures.append(lecture)
                    
                    // add the newly fetched lecture to the cache
                    self.cachedLectures[lectureId] = lecture
                    
                    // fetch the lecture thumbnail from storage
                    self.getLectureThumnbnail(lectureId: lectureId)
                    
                    // fetch the channel
                    self.retrieveChannel(channelId: lecture.channelId!)
                } catch {
                    print("Error decoding lecture: \(error)")
                }
            }
            
            self.lecturesInCourse[courseId] = lectures
        }
    }
    
    // ---------- Focus Functions ----------
    func focusCourse(_ course: Course) {
        self.focusedCourse = nil
        self.focusedCourse = course
        
        // TODO: add some logic to avoid duplicate calls to storage
        // When a course gets focused we want to make sure the channel's thumbnail is loaded and ready to display on Courseview
        self.getChannelThumbnail(channelId: course.channelId!)
    }
    
    func focusLecture(_ lecture: Lecture) {
        print("lecture is being focused")
        self.focusedLecture = nil
        self.focusedLecture = lecture
        
        // When a lecture gets focused we want to make sure the channel's thumbnail is loaded and ready to display on LectureView
        self.getChannelThumbnail(channelId: lecture.channelId!)
    }
    
    func focusChannel(_ channel: Channel) {
        self.focusedChannel = nil
        self.focusedChannel = channel
        
        // get channel thumbnail
        self.getChannelThumbnail(channelId: channel.id!)
        
        // When we're focusing the channel, we know we want to look at the list of that channel's courses
        // we have a list of each courseId under this channel, we should retrieve each one and cache them if they are not already cached
        
        for courseId in channel.courseIds! {
            self.retrieveCourse(courseId: courseId)
        }
    }
    
    // ---------- Fetch Thumbnail (Storage) ----------
    func getCourseThumbnail(courseId: String) {
        // check if request was already made for this course
        if let request = self.courseThumbnailRequestQueue[courseId] {
            // make sure it's set to true, if we failed to retrieve thumbnail, we'll set the bool val back to false
            if request {
                print("we already requested this course thumbnail")
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
                    // Data for image is returned
                    let image = UIImage(data: data!)
                    // Add image to cache
                    self.courseThumbnails[courseId] = image
                }
            }
        }
    }
    
    func getLectureThumnbnail(lectureId: String) {
        
        // check if request was already made for this course
        if let request = self.lectureThumbnailRequestQueue[lectureId] {
            // make sure it's set to true, if we failed to retrieve thumbnail, we'll set the bool val back to false
            if request {
                print("we already requested this lecture thumbnail")
                return
            }
        }
        
        // first time requesting this thumbnail, process the request
        self.lectureThumbnailRequestQueue[lectureId] = true
        
        // check cache
        if let _ = self.lectureThumbnails[lectureId] {
            //            print("lecture thumbnail already cached")
            return
        }
        
        Task {
            let storage = Storage.storage()

            // Create a storage reference from our storage service
            let storageRef = storage.reference()
            
            // Fetch the prompts image from storage
            let imageRef = storageRef.child("lectures/" + lectureId + ".jpeg")
            
            // download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("error downloading image from storage: ", error.localizedDescription)
                    // There was an issue with the image or the image doesn't exist, either way set both prompt and promptImage back to nil
                    return
                } else {
                    // Data for image is returned
                    let image = UIImage(data: data!)
                    // Add image to cache
                    self.lectureThumbnails[lectureId] = image
                }
            }
        }
    }
    
    func getChannelThumbnail(channelId: String) {
        // check if request was already made for this course
        if let request = self.channelThumbnailRequestQueue[channelId] {
            // make sure it's set to true, if we failed to retrieve thumbnail, we'll set the bool val back to false
            if request {
                print("we already requested this channel thumbnail")
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
                    // Data for image is returned
                    let image = UIImage(data: data!)
                    // Add image to cache
                    self.channelThumbnails[channelId] = image
                }
            }
        }
    }
}
