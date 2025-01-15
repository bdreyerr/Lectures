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
    @Published var isUniversityLoading: Bool = true
    @Published var isCuratedCoursesLoading: Bool = true
    @Published var isCommunityFavoritesLoading: Bool = true
    
//    // Sorted versions of homepage content
//    @Published var leadingUniversitiesFiltered : [String : [Channel]]
    
    @Published var isCourseLoading: Bool = false
    @Published var isLectureLoading: Bool = false
    
    @Published var focusedCourse: Course?
    @Published var focusedLecture: Lecture?
    @Published var focusedChannel: Channel?
    @Published var focusedCollection: Collection?
    
    // stack of lectures and courses for naviagtion. These are needed because when navigating backwards we lost track of which course / lecture was focused at that point
    // Focused lecture Stack
    @Published var focusedLectureStack: [Lecture] = []
    @Published var focusedCourseStack: [Course] = []
    
    // CourseId : [Lecture]
    @Published var lecturesInCourse: [String : [Lecture]] = [:]
    
    // CourseId : Course
    @Published var cachedCourses: [String : Course] = [:]
    // LectureId : Course
    @Published var cachedLectures: [String : Lecture] = [:]
    // ChannelId: Channel
    @Published var cachedChannels: [String : Channel] = [:]
    
    
    // CourseId : UIImage
    @Published var courseThumbnails: [String : UIImage] = [:]
    // LectureId : UIImage
    @Published var lectureThumbnails: [String : UIImage] = [:]
    // ChannelId : UIImage
    @Published var channelThumbnails: [String : UIImage] = [:]
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    
    init() {
        // load the preview list for courses on the home page
        self.isCommunityFavoritesLoading = true
        self.isCuratedCoursesLoading = true
        self.isUniversityLoading = true
        retrieveLeadingUniversities()
        retrieveCuratedCourses()
        retrieveCommunityFavorites()
    }
    
    func retrieveCourse(courseId: String) {
        // check the cache
        if let _ = cachedCourses[courseId] {
            print("course already cached")
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
            print("channel already cached")
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
    
    func retrieveLeadingUniversities() {
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
                    self.cachedChannels[channelId] = channel
                    
                    // TODO: add some logic to not duplicate calls
                    // get the thumbnail for the channels
                    self.getChannelThumbnail(channelId: channelId)
                    
                } catch {
                    print("Error decoding channel: \(error)")
                }
            }
            
            self.isUniversityLoading = false
        }
    }
    
    func retrieveCuratedCourses() {
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
                        self.cachedCourses[course.id!] = course
                        
                        // TODO: add some logic to avoid making duplicate calls
                        // fetch the courses thumbnail
                        self.getCourseThumbnail(courseId: course.id!)
                        
                        // fetch the channel
                        self.retrieveChannel(channelId: course.channelId!)
                    }
                }
                
                self.isCuratedCoursesLoading = false
            } catch let error {
                print("error getting community favorites from firestore: ", error)
            }
        }
    }
    
    func retrieveCommunityFavorites() {
        
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
                        self.cachedCourses[course.id!] = course
                        
                        // fetch the courses thumbnail
                        self.getCourseThumbnail(courseId: course.id!)
                        
                        // fetch the channel
                        self.retrieveChannel(channelId: course.channelId!)
                    }
                }
                
                self.isCommunityFavoritesLoading = false
            } catch let error {
                print("error getting community favorites from firestore: ", error)
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
    
    func focusCourse(_ course: Course) {
        
        // Code to run after 1 second
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
    
    func focusCollection(_ collection: Collection) {
        print("collection getting focused")
        self.focusedCollection = nil
        self.focusedCollection = collection
    }
    
    func getCourseThumbnail(courseId: String) {
        // check cache
        if let _ = self.courseThumbnails[courseId] {
            print("course thumbnail already cached")
        }
        
        // Fetch image from firestore
        Task {
            // Fetch the prompts image from storage
            let imageRef = self.storage.reference().child("courses/" + courseId + ".jpeg")
                        
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
                    self.courseThumbnails[courseId] = image
                }
            }
        }
    }
    
    func getLectureThumnbnail(lectureId: String) {
        // check cache
        if let _ = self.lectureThumbnails[lectureId] {
            print("lecture thumbnail already cached")
        }
        
        Task {
            // Fetch the prompts image from storage
            let imageRef = self.storage.reference().child("lectures/" + lectureId + ".jpeg")
                        
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
        // check cache
        if let _ = self.channelThumbnails[channelId] {
            print("channel thumbnail already cached")
        }
        
        Task {
            // Fetch the prompts image from storage
            let imageRef = self.storage.reference().child("channels/" + channelId + ".jpeg")
                        
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
                    self.channelThumbnails[channelId] = image
                }
            }
        }
    }
}
