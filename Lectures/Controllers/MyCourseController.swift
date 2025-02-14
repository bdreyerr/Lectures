//
//  WatchHistoryController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/15/25.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation


class MyCourseController : ObservableObject {
    
    @Published var watchHistories: [WatchHistory] = []
    
    // Pagination
    @Published var lastWatchHistoryDoc: QueryDocumentSnapshot?
    @Published var noWatchHistoriesLeftToLoad: Bool = false
    
    // CourseId : WatchHistory
    @Published var cachedWatchHistories: [String : WatchHistory] = [:]
    
    // Loading
    @Published var isWatchHistoryLoading: Bool = false
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    // Add these properties to the class
    @Published var currentChannelOffset: Int = 8
    @Published var currentCourseOffset: Int = 8
    @Published var currentLectureOffset: Int = 8
    
    
    func updateWatchHistory(userId: String, course: Course, lecture: Lecture) {
        Task { @MainActor in
            if let courseId = course.id, let numLecturesInCourse = course.numLecturesInCourse, let courseChannelId = course.channelId, let numLecturesInCourse = course.numLecturesInCourse, let lectureId = lecture.id, let currentLectureNumberInCourse  = lecture.lectureNumberInCourse {
                
                // check the cache, if a watchHistory is already in there, and the new lecture being watched isn't greater than the already highest watched lecture, we don't need to do anything
                if let watchHistory = cachedWatchHistories[courseId], let watchHistoryLectureNumberInCourse  = watchHistory.lectureNumberInCourse {
                    if watchHistoryLectureNumberInCourse >= currentLectureNumberInCourse {
                        print("returning early from cache - new lecture not greater - watch history")
                        return
                    }
                }
                
                
                // check if a watch history exists for this course already - if it does, update that same document. otherwise create a new one and store it in firestore
                do {
                    // determine if course is completed or not - if this is the last lecture
                    var isCourseCompleted = false
                    if currentLectureNumberInCourse == numLecturesInCourse {
                        isCourseCompleted = true
                    }
                    
                    let watchHistory = WatchHistory(userId: userId, courseId: courseId, lectureId: lectureId, channelId: courseChannelId, lectureNumberInCourse: currentLectureNumberInCourse, numLecturesInCourse: numLecturesInCourse, courseLastWatched: Timestamp(), isCourseCompleted: isCourseCompleted)
                    
                    
                    let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).whereField("courseId", isEqualTo: courseId).getDocuments()
                    
                    // There's not an existing watch history so make a new one
                    if querySnapshot.documents.isEmpty {
                        print(" this is a new watch history, we're adding it")
                        // write this new object to firestore
                        do {
                            try db.collection("watchHistories").addDocument(from: watchHistory)
                            
                            // add the watch history to the cache
                            self.cachedWatchHistories[courseId] = watchHistory
                        } catch let error {
                            print("error writing new free watch history to firestore: ", error.localizedDescription)
                        }
                        
                        self.refreshCourseHistory(userId: userId)
                        return
                    }
                    
                    for document in querySnapshot.documents {
                        print("we've got an existing watch history for this user and this course: \(document.documentID)")
                        // update the existing wathch History
                        
                        // ONLY IF THE NEW LECTURE NUMBER IS HIGHER THAN THE PREVIOUS. THIS MEANS YOUR WATCH HISTORY PROGRESS CAN ONLY MOVE FORWARDS, NOT BACKWARDS. (e.g. if you previously had watched lecture 3, then you went back and watched lecture 1, the watch history will remain on lecture 3)
                        if let previousWatchHistory = try? document.data(as: WatchHistory.self) {
                            if let previousLectureNumberInCourse = previousWatchHistory.lectureNumberInCourse {
                                if let newLectureNumberInCourse = watchHistory.lectureNumberInCourse {
                                    if previousLectureNumberInCourse >= newLectureNumberInCourse {
                                        return
                                    }
                                }
                            }
                        }
                        
                        do {
                            try db.collection("watchHistories").document(document.documentID).setData(from: watchHistory)
                            // add the watch history to the cache
                            self.cachedWatchHistories[courseId] = watchHistory
                        } catch let error {
                            print("Error writing watch history to Firestore: \(error)")
                        }
                        
                        
                        self.refreshCourseHistory(userId: userId)
                        return
                    }
                } catch {
                    print("error getting watch history: \(error)")
                }
            } else {
                print("some values are nil?")
            }
        }
    }
    
    // get a user's recently watched courses (on app open)
    func retrieveRecentWatchHistories(userId: String, courseController: CourseController) {
        // TODO: find a better way to refresh this? for now if it's already filled we won't check firestore again
        if self.watchHistories.count > 0 {
            print("skipping getting recent watch history again")
            return
        }
        
        self.isWatchHistoryLoading = true
        Task { @MainActor in
            self.watchHistories = []
            do {
                let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).order(by: "courseLastWatched", descending: true).limit(to: 6).getDocuments()
                
                
                if querySnapshot.documents.isEmpty { noWatchHistoriesLeftToLoad = true }
                
                for document in querySnapshot.documents {
                    // build the watchHistory object and add it
                    if let watchHistory = try? document.data(as: WatchHistory.self) {
                        if let watchHistoryCourseId = watchHistory.courseId, let watchHistoryChannelId = watchHistory.channelId {
                            self.watchHistories.append(watchHistory)
                            self.cachedWatchHistories[watchHistoryCourseId] = watchHistory
                            
                            
                            courseController.retrieveCourse(courseId: watchHistoryCourseId)
                            courseController.retrieveChannel(channelId: watchHistoryChannelId)
                            courseController.getCourseThumbnail(courseId: watchHistoryCourseId)
                        }
                        
                    } else {
                        print("couldn't convert the document to a watch history")
                    }
                }
                
                // get the last doc for pagination
                guard let lastDocument = querySnapshot.documents.last else {
                    // the collection is empty
                    isWatchHistoryLoading = false
                    return
                }
                
                self.lastWatchHistoryDoc = lastDocument
                
                self.isWatchHistoryLoading = false
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    
    func refreshCourseHistory(userId: String) {
        Task { @MainActor in
            self.watchHistories = []
            do {
                let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).order(by: "courseLastWatched", descending: true).limit(to: 6).getDocuments()
                
                if querySnapshot.documents.isEmpty { noWatchHistoriesLeftToLoad = true }
                
                for document in querySnapshot.documents {
                    // build the watchHistory object and add it
                    if let watchHistory = try? document.data(as: WatchHistory.self) {
                        if let watchHistoryCourseId = watchHistory.courseId {
                            self.watchHistories.append(watchHistory)
                            self.cachedWatchHistories[watchHistoryCourseId] = watchHistory
                        }
                    } else {
                        print("couldn't convert the document to a watch history")
                    }
                }
                
                // get the last doc for pagination
                guard let lastDocument = querySnapshot.documents.last else {
                    // the collection is empty
                    return
                }
                
                self.lastWatchHistoryDoc = lastDocument
                
                self.isWatchHistoryLoading = false
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    // Load first 8 channels, rest need to be paginated.
    func retrieveFollowedChannels(channelIds: [String], courseController: CourseController) {
        Task { @MainActor in
            currentChannelOffset = 8  // Reset the offset
            let initialChannels = channelIds.prefix(currentChannelOffset)
            for channelId in initialChannels {
                courseController.retrieveChannel(channelId: channelId)
                courseController.getChannelThumbnail(channelId: channelId)
            }
        }
    }
    
    // Load first 8 courses, rest need to be paginated.
    func retrieveLikedCourses(courseIds: [String], courseController: CourseController) {
        Task { @MainActor in
            currentCourseOffset = 8  // Reset the offset
            let initialCourses = courseIds.prefix(currentCourseOffset)
            for courseId in initialCourses {
                courseController.retrieveCourse(courseId: courseId)
                courseController.getCourseThumbnail(courseId: courseId)
            }
        }
    }
    
    // Load first 8 lectures, rest need to be paginated.
    func retrieveLikedLectures(lectureIds: [String], courseController: CourseController) {
        Task { @MainActor in
            currentLectureOffset = 2  // Reset the offset
            let initialLectures = lectureIds.prefix(currentLectureOffset)
            for lectureId in initialLectures {
                courseController.retrieveLecture(lectureId: lectureId)
                courseController.getLectureThumnbnail(lectureId: lectureId)
            }
        }
    }
    
    // pagination of watch history
    func getMoreWatchHistories(userId: String, courseController: CourseController) {
        if let lastDoc = self.lastWatchHistoryDoc {
            Task { @MainActor in
                do {
                    let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).order(by: "courseLastWatched", descending: true).start(afterDocument: lastDoc).limit(to: 6).getDocuments()
                    
                    
                    if querySnapshot.documents.isEmpty { noWatchHistoriesLeftToLoad = true }
                    
                    for document in querySnapshot.documents {
                        // build the watchHistory object and add it
                        if let watchHistory = try? document.data(as: WatchHistory.self) {
                            if let watchHistoryCourseId = watchHistory.courseId, let watchHistoryChannelId = watchHistory.channelId {
                                self.watchHistories.append(watchHistory)
                                self.cachedWatchHistories[watchHistoryCourseId] = watchHistory
                                
                                
                                courseController.retrieveCourse(courseId: watchHistoryCourseId)
                                courseController.retrieveChannel(channelId: watchHistoryChannelId)
                                courseController.getCourseThumbnail(courseId: watchHistoryCourseId)
                            }
                            
                        } else {
                            print("couldn't convert the document to a watch history")
                        }
                    }
                    
                    // get the last doc for pagination
                    guard let lastDocument = querySnapshot.documents.last else {
                        // the collection is empty
                        return
                    }
                    
                    self.lastWatchHistoryDoc = lastDocument
                    
                    self.isWatchHistoryLoading = false
                } catch {
                    print("Error getting documents: \(error)")
                }
            }
        }
    }
    
    // Add these new functions
    func loadMoreFollowedChannels(channelIds: [String], courseController: CourseController) {
        Task { @MainActor in
            let nextChannels = channelIds[currentChannelOffset..<min(currentChannelOffset + 8, channelIds.count)]
            for channelId in nextChannels {
                courseController.retrieveChannel(channelId: channelId)
                courseController.getChannelThumbnail(channelId: channelId)
            }
            currentChannelOffset += 8
        }
    }

    func loadMoreLikedCourses(courseIds: [String], courseController: CourseController) {
        Task { @MainActor in
            let nextCourses = courseIds[currentCourseOffset..<min(currentCourseOffset + 8, courseIds.count)]
            for courseId in nextCourses {
                courseController.retrieveCourse(courseId: courseId)
                courseController.getCourseThumbnail(courseId: courseId)
            }
            currentCourseOffset += 8
        }
    }

    func loadMoreLikedLectures(lectureIds: [String], courseController: CourseController) {
        Task { @MainActor in
            let nextLectures = lectureIds[currentLectureOffset..<min(currentLectureOffset + 2, lectureIds.count)]
            for lectureId in nextLectures {
                courseController.retrieveLecture(lectureId: lectureId)
                courseController.getLectureThumnbnail(lectureId: lectureId)
            }
            currentLectureOffset += 2
        }
    }
}
