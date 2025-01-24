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
    
    @Published var recentWatchHistories : [WatchHistory] = []
    
    // CourseId : WatchHistory
    @Published var cachedWatchHistories : [String : WatchHistory] = [:]
    
    
    // Loading
    @Published var isWatchHistoryLoading: Bool = false
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    func updateWatchHistory(userId: String, course: Course, lecture: Lecture) {
        Task { @MainActor in
            if let courseId = course.id, let numLecturesInCourse = course.numLecturesInCourse, let courseChannelId = course.channelId, let numLecturesInCourse = course.numLecturesInCourse, let lectureId = lecture.id, let currentLectureNumberInCourse  = lecture.lectureNumberInCourse {
                
                // check the cache, if a watchHistory is already in there, and the new lecture being watched isn't greater than the already highest watched lecture, we don't need to do anything
                if let watchHistory = cachedWatchHistories[courseId], let watchHistoryLectureNumberInCourse  = watchHistory.lectureNumberInCourse {
                    if watchHistoryLectureNumberInCourse >= currentLectureNumberInCourse {
                        return
                    }
                }
                
                
                // check if a watch history exists for this course already - if it does, update that same document. otherwise create a new one and store it in firestore
                do {
                    // determine if course is completed or not - if this is the last lecture
                    // TODO: determine form the watch time in the last lecture
                    var isCourseCompleted = false
                    if currentLectureNumberInCourse == numLecturesInCourse {
                        isCourseCompleted = true
                    }
                    
                    let watchHistory = WatchHistory(userId: userId, courseId: courseId, lectureId: lectureId, channelId: courseChannelId, lectureNumberInCourse: currentLectureNumberInCourse, numLecturesInCourse: numLecturesInCourse, courseLastWatched: Timestamp(), isCourseCompleted: isCourseCompleted)
                    
                    
                    let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).whereField("courseId", isEqualTo: courseId).getDocuments()
                    
                    // There's not an existing watch history so make a new one
                    if querySnapshot.documents.isEmpty {
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
                            //                        print("the previous watch history lecture number: \(previousWatchHistory.lectureNumberInCourse)")
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
                        
                        
                        // refresh the user's watch history (so they dn't have to re-open app to see changes
                        self.refreshCourseHistory(userId: userId) // might break passing the nil course controller, but we don't need it on a refresh
                        return
                    }
                } catch {
                    print("error getting watch history: \(error)")
                }
            }
        }
    }
    
    // get a user's recently watched courses (on app open)
    func retrieveRecentWatchHistories(userId: String, courseController: CourseController) {
        // TODO: find a better way to refresh this? for now if it's already filled we won't check firestore again
        if self.recentWatchHistories.count > 0 {
            print("skipping getting recent watch history again")
            return
        }
        
        self.isWatchHistoryLoading = true
        Task { @MainActor in
            self.recentWatchHistories = []
            do {
                let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).order(by: "courseLastWatched", descending: true).limit(to: 10).getDocuments()
                
                for document in querySnapshot.documents {
                    // build the watchHistory object and add it
                    if let watchHistory = try? document.data(as: WatchHistory.self) {
                        if let watchHistoryCourseId = watchHistory.courseId, let watchHistoryChannelId = watchHistory.channelId {
                            self.recentWatchHistories.append(watchHistory)
                            self.cachedWatchHistories[watchHistoryCourseId] = watchHistory
                            
                            
                            courseController.retrieveCourse(courseId: watchHistoryCourseId)
                            courseController.retrieveChannel(channelId: watchHistoryChannelId)
                            courseController.getCourseThumbnail(courseId: watchHistoryCourseId)
                        }
                        
                    } else {
                        print("couldn't convert the document to a watch history")
                    }
                }
                
                self.isWatchHistoryLoading = false
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    
    func refreshCourseHistory(userId: String) {
        Task { @MainActor in
            self.recentWatchHistories = []
            do {
                let querySnapshot = try await db.collection("watchHistories").whereField("userId", isEqualTo: userId).order(by: "courseLastWatched", descending: true).limit(to: 10).getDocuments()
                
                for document in querySnapshot.documents {
                    // build the watchHistory object and add it
                    if let watchHistory = try? document.data(as: WatchHistory.self) {
                        if let watchHistoryCourseId = watchHistory.courseId {
                            self.recentWatchHistories.append(watchHistory)
                            self.cachedWatchHistories[watchHistoryCourseId] = watchHistory
                        }
                    } else {
                        print("couldn't convert the document to a watch history")
                    }
                }
                
                self.isWatchHistoryLoading = false
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    
    func retrieveFollowedChannels(channelIds: [String], courseController: CourseController) {
        Task { @MainActor in            
            for channelId in channelIds {
                courseController.retrieveChannel(channelId: channelId)
                courseController.getChannelThumbnail(channelId: channelId)
            }
        }
    }
    
    func retrieveLikedCourses(courseIds: [String], courseController: CourseController) {
        Task { @MainActor in
            for courseId in courseIds {
                courseController.retrieveCourse(courseId: courseId)
                courseController.getCourseThumbnail(courseId: courseId)
            }
        }
    }
    
    func retrieveLikedLectures(lectureIds: [String], courseController: CourseController) {
        Task { @MainActor in
            for lectureId in lectureIds {
                courseController.retrieveLecture(lectureId: lectureId)
                courseController.getLectureThumnbnail(lectureId: lectureId)
            }
        }
    }
}
