//
//  SearchController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/18/25.
//

import FirebaseFirestore
import Foundation

class SearchController : ObservableObject {
    @Published var searchText: String = ""
    @Published var areFiltersShowing: Bool = false
    
    @Published var searchResultCourses: [Course] = []
    @Published var searchResultLectures: [Lecture] = []
    @Published var searchResultChannels: [Channel] = []
    
    // Loading vars
    @Published var isCoursesLoading: Bool = false
    @Published var isLecturesLoading: Bool = false
    @Published var isChannelsLoading: Bool = false
    
    // Filters
    
    // Search result type
    @Published var isLectureFilterSelected: Bool = true
    @Published var isCourseFilterSelected: Bool = true
    @Published var isChannelFilterSelected: Bool = true
    
    // Category list
    @Published var categoryList: [String] = ["Computer Science", "Engineering", "Mathematics", "Natural Sciences", "Business", "Economics", "Finance", "History", "Philosophy", "Sociology", "Psychology", "Literature", "Design", "Medicine", "Health", "Education", "Language"]
    // use this in query to Firestore
    @Published var activeCategories: [String] = []
    
    // Course size filters
    @Published var lessThanFiveLectures: Bool = false
    @Published var greaterThanFiveLectures: Bool = false
    @Published var greaterThanTenLectures: Bool = false
    
    // Sory by filters
    @Published var sortByMostWatched: Bool = true
    @Published var sortByMostLiked: Bool = false
    
    
    // Firestore
    let db = Firestore.firestore()
    
    func clearSearchResults() {
        searchResultCourses = []
        searchResultLectures = []
        searchResultChannels = []
    }
    
    func performSearch(courseController: CourseController) async {
        guard searchText.count >= 2 else {
            searchResultCourses = []
            searchResultLectures = []
            searchResultChannels = []
            return
        }
        
        DispatchQueue.main.async {
            self.searchResultCourses = []
            self.searchResultLectures = []
            self.searchResultChannels = []
        }
        
        
        // Create search terms for case-insensitive search
        var searchTerms = searchText.lowercased().split(separator: " ").map(String.init)
        
        // search course
        if isCourseFilterSelected {
            DispatchQueue.main.async {
                self.isCoursesLoading = true
            }
            
            do {
                
                if !activeCategories.isEmpty {
//                    courseQuery = courseQuery.whereField("categories", arrayContainsAny: activeCategories)
                    
                    // instead of adding another arraycontains any, just add each selected category into the searchTerms
                    
                    for category in activeCategories {
                        let categoryTerms = category.lowercased().split(separator: " ").map(String.init)
                        for term in categoryTerms {
                            searchTerms.append(term)
                        }
                        print("we have categories, here's current search terms: ", searchTerms)
                    }
                }
                
                var courseQuery = db.collection("courses").whereField("searchTerms", arrayContainsAny: searchTerms)
                
                // Apply course size filters
                if lessThanFiveLectures {
                    courseQuery = courseQuery.whereField("numLecturesInCourse", isLessThan: 5)
                } else if greaterThanFiveLectures {
                    courseQuery = courseQuery.whereField("numLecturesInCourse", isGreaterThan: 5)
                } else if greaterThanTenLectures {
                    courseQuery = courseQuery.whereField("numLecturesInCourse", isGreaterThan: 10)
                }
                
                // Apply sorting
                if sortByMostWatched {
                    // TODO: switch aggregate views to an int, rn it's a string
                    courseQuery = courseQuery.order(by: "aggregateViews", descending: true)
                } else if sortByMostLiked {
                    courseQuery = courseQuery.order(by: "numLikesInApp", descending: true)
                }
                
                let snapshot = try await courseQuery.limit(to: 8).getDocuments()
                
                DispatchQueue.main.async {
                    self.searchResultCourses = snapshot.documents.compactMap { document -> Course? in
                        let course = try? document.data(as: Course.self)
                        
                        if let course = course {
                            courseController.cachedCourses[course.id!] = course
                            
                            courseController.getCourseThumbnail(courseId: course.id!)
                            
                            courseController.retrieveChannel(channelId: course.channelId!)
                        } else {
                            print("course was nil")
                        }
                        return course
                    }
                }
            } catch let error {
                print("error fetching courses: ", error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.isCoursesLoading = false
            }
        }
    }
    
    func performSearchPlacerholder(courseController: CourseController) {
        Task { @MainActor in
            searchCourses(courseController: courseController)
            searchLectures(courseController: courseController)
            searchChannels(courseController: courseController)
        }
    }
    
    func searchCourses(courseController: CourseController) {
        // just return the top 2 courses by num likes
        self.searchResultCourses = []
        isCoursesLoading = true
        
        Task { @MainActor in
            do {
                let querySnapshot = try await db.collection("courses").order(by: "numLikesInApp", descending: true).limit(to: 3).getDocuments()
                
                if querySnapshot.isEmpty {
                    print("no courses returned when looking up community favorites")
                    return
                }
                
                for document in querySnapshot.documents {
                    if let course = try? document.data(as: Course.self) {
                        self.searchResultCourses.append(course)
                        
                        // add the course to the cache
                        courseController.cachedCourses[course.id!] = course
                        
                        // TODO: add some logic to avoid making duplicate calls
                        // fetch the courses thumbnail
                        courseController.getCourseThumbnail(courseId: course.id!)
                        
                        // fetch the channel
                        courseController.retrieveChannel(channelId: course.channelId!)
                    }
                }
                isCoursesLoading = false
            } catch let error {
                print("error: ", error.localizedDescription)
            }
        }
    }
    
    func searchLectures(courseController: CourseController) {
        // just return the top 2 lectures by num likes
        self.searchResultLectures = []
        isLecturesLoading = true
        
        Task { @MainActor in
            do {
                let querySnapshot = try await db.collection("lectures").order(by: "numLikesInApp", descending: true).limit(to: 3).getDocuments()
                
                if querySnapshot.isEmpty {
                    print("no courses returned when looking up community favorites")
                    return
                }
                
                for document in querySnapshot.documents {
                    if let lecture = try? document.data(as: Lecture.self) {
                        self.searchResultLectures.append(lecture)
                        
                        
                        // add the course to the cache
                        courseController.cachedLectures[lecture.id!] = lecture
                        
                        // TODO: add some logic to avoid making duplicate calls
                        // fetch the courses thumbnail
                        courseController.getLectureThumnbnail(lectureId: lecture.id!)
                        
                        // fetch the channel
                        courseController.retrieveChannel(channelId: lecture.channelId!)
                    }
                }
                isLecturesLoading = false
            } catch let error {
                print("error")
            }
        }
    }
    
    func searchChannels(courseController: CourseController) {
        // just return top 2 channels by # course
        self.searchResultLectures = []
        isChannelsLoading = true
        
        Task { @MainActor in
            do {
                let querySnapshot = try await db.collection("channels").order(by: "numCourses", descending: true).limit(to: 3).getDocuments()
                
                if querySnapshot.isEmpty {
                    print("no courses returned when looking up community favorites")
                    return
                }
                
                for document in querySnapshot.documents {
                    if let channel = try? document.data(as: Channel.self) {
                        self.searchResultChannels.append(channel)
                        
                        courseController.cachedChannels[channel.id!] = channel
                        
                        courseController.getChannelThumbnail(channelId: channel.id!)
                    }
                }
                isChannelsLoading = false
            } catch let error {
                print("error")
            }
        }
    }
    
}
