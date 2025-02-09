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
    
    @Published var wasSearchPerformed = false
    @Published var displaySearchGraphic = true
    
    // Pagination
    @Published var lastDocChannel: QueryDocumentSnapshot?
    @Published var lastDocCourse: QueryDocumentSnapshot?
    @Published var lastDocLecture: QueryDocumentSnapshot?
    
    @Published var noChannelsLeftToLoad: Bool = false
    @Published var noCoursesLeftToLoad: Bool = false
    @Published var noLecturesLeftToLoad: Bool = false
    
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
        
        isCoursesLoading = false
        isLecturesLoading = false
        isChannelsLoading = false
        
        noCoursesLeftToLoad = false
        noLecturesLeftToLoad = false
        noChannelsLeftToLoad = false
        
        wasSearchPerformed = false
        displaySearchGraphic = true
    }
    
    func performSearch(courseController: CourseController) {
        Task { @MainActor in
            guard searchText.count >= 2 else {
                searchResultCourses = []
                searchResultLectures = []
                searchResultChannels = []
                return
            }
            self.displaySearchGraphic = false
            self.wasSearchPerformed = false
            
            self.searchResultCourses = []
            self.searchResultLectures = []
            self.searchResultChannels = []
            
            
            
            
            // Create search terms for case-insensitive search
            var searchTerms = searchText.lowercased().split(separator: " ").map(String.init)
            
            if !activeCategories.isEmpty {
                
                // add categories into search terms
                for category in activeCategories {
                    let categoryTerms = category.lowercased().split(separator: " ").map(String.init)
                    for term in categoryTerms {
                        searchTerms.append(term)
                    }
//                    print("we have categories, here's current search terms: ", searchTerms)
                }
            }
            
            let trimmedSearchTerms = searchTerms.map { $0.trimmingCharacters(in: .whitespaces) }
            
            // search courses
            if isCourseFilterSelected {
                self.isCoursesLoading = true
                
                do {
                    var courseQuery = db.collection("courses").whereField("searchTerms", arrayContainsAny: trimmedSearchTerms)
                    
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
                    
                    let courseSnapshot = try await courseQuery.limit(to: 1).getDocuments()
                    
                    if courseSnapshot.documents.isEmpty { noCoursesLeftToLoad = true }
                    
                    self.searchResultCourses = courseSnapshot.documents.compactMap { document -> Course? in
                        let course = try? document.data(as: Course.self)
                        
                        if let course = course, let courseId = course.id, let channelId = course.channelId {
                            courseController.cachedCourses[courseId] = course
                            
                            courseController.getCourseThumbnail(courseId: courseId)
                            
                            courseController.retrieveChannel(channelId: channelId)
                        } else {
                            print("course was nil")
                        }
                        return course
                    }
                    
                    // get the last doc for pagination
                    if let lastCourseDocument = courseSnapshot.documents.last {
                        self.lastDocCourse = lastCourseDocument
                    }
                    
                } catch let error {
                    print("error fetching courses: ", error.localizedDescription)
                }
                
                self.isCoursesLoading = false
            }
            
            if isLectureFilterSelected {
                self.isLecturesLoading = true
                
                do {
                    var lectureQuery = db.collection("lectures").whereField("searchTerms", arrayContainsAny: trimmedSearchTerms)
                    
                    // for lectures, we'd prefer to show results for the earliest lecture in the course if possible, so let's try to order them by that field
                    lectureQuery = lectureQuery.order(by: "lectureNumberInCourse")
                    
//                    // Apply sorting
                    if sortByMostWatched {
                        // TODO: switch views on Youtube to an int, rn it's a string
                        lectureQuery = lectureQuery.order(by: "viewsOnYouTube", descending: true)
                    } else if sortByMostLiked {
                        lectureQuery = lectureQuery.order(by: "numLikesInApp", descending: true)
                    }
                    
                    
                    
                    
                    let lectureSnapshot = try await lectureQuery.limit(to: 1).getDocuments()
                    
                    if lectureSnapshot.documents.isEmpty { noLecturesLeftToLoad = true }
                    
                    self.searchResultLectures = lectureSnapshot.documents.compactMap { document -> Lecture? in
                        let lecture = try? document.data(as: Lecture.self)
                        
                        if let lecture = lecture, let lectureId = lecture.id, let channelId = lecture.channelId {
                            courseController.cachedLectures[lectureId] = lecture
                            
                            courseController.getLectureThumnbnail(lectureId: lectureId)
                            
                            courseController.retrieveChannel(channelId: channelId)
                        } else {
                            print("lecture was nil")
                        }
                        return lecture
                    }
                    
                    // get the last doc for pagination
                    if let lastLectureDocument = lectureSnapshot.documents.last {
                        self.lastDocLecture = lastLectureDocument
                    }
                    
                } catch let error {
                    print("error searching lectures: ", error.localizedDescription)
                }
                
                self.isLecturesLoading = false
            }
            
            if isChannelFilterSelected {
                isChannelsLoading = true
                
                do {
                    let channelQuery = db.collection("channels").whereField("searchTerms", arrayContainsAny: trimmedSearchTerms)
                    
                    let channelSnapshot = try await channelQuery.limit(to: 1).getDocuments()
                    
                    if channelSnapshot.documents.isEmpty { noChannelsLeftToLoad = true }
                    
                    self.searchResultChannels = channelSnapshot.documents.compactMap { document -> Channel? in
                        let channel = try? document.data(as: Channel.self)
                        
                        if let channel = channel, let channelId = channel.id {
                            courseController.cachedChannels[channelId] = channel
                            
                            courseController.getChannelThumbnail(channelId: channelId)
                        }
                        
                        return channel
                    }
                    
                    // get the last doc for pagination
                    if let lastChannelDocument = channelSnapshot.documents.last {
                        self.lastDocChannel = lastChannelDocument
                    }
                    
                } catch let error {
                    print("error searching channels: ", error.localizedDescription)
                }
                
                isChannelsLoading = false
            }
            
            self.wasSearchPerformed = true
        }
    }
    
    func getMoreChannels(courseController: CourseController) {
        // return early if last doc isn't populated
        if let lastDocChannel = self.lastDocChannel {
            Task { @MainActor in
                // Create search terms for case-insensitive search
                var searchTerms = searchText.lowercased().split(separator: " ").map(String.init)
                
                if !activeCategories.isEmpty {
                    
                    // add categories into search terms
                    for category in activeCategories {
                        let categoryTerms = category.lowercased().split(separator: " ").map(String.init)
                        for term in categoryTerms {
                            searchTerms.append(term)
                        }
    //                    print("we have categories, here's current search terms: ", searchTerms)
                    }
                }
                
                let trimmedSearchTerms = searchTerms.map { $0.trimmingCharacters(in: .whitespaces) }
                
                do {
                    let channelQuery = db.collection("channels").whereField("searchTerms", arrayContainsAny: trimmedSearchTerms)
                    
                    let channelSnapshot = try await channelQuery.limit(to: 1).start(afterDocument: lastDocChannel).getDocuments()
                    
                    if channelSnapshot.documents.isEmpty {
                        noChannelsLeftToLoad = true
                        return
                    }
                    
                    self.searchResultChannels.append(contentsOf: channelSnapshot.documents.compactMap { document -> Channel? in
                        let channel = try? document.data(as: Channel.self)
                        
                        if let channel = channel, let channelId = channel.id {
                            courseController.cachedChannels[channelId] = channel
                            
                            courseController.getChannelThumbnail(channelId: channelId)
                        }
                        
                        return channel
                    })
                    
                    // get the last doc for pagination
                    guard let lastChannelDocument = channelSnapshot.documents.last else {
                        // the collection is empty
                        return
                    }
                    
                    self.lastDocChannel = lastChannelDocument
                    
                } catch let error {
                    print("error searching channels: ", error.localizedDescription)
                }
                
            }
            
        }
    }
    
    func getMoreCourses(courseController: CourseController) {
        // return early if last doc isn't populated
        if let lastDocCourse = self.lastDocCourse {
            
            Task { @MainActor in
                // build search terms
                var searchTerms = searchText.lowercased().split(separator: " ").map(String.init)
                
                if !activeCategories.isEmpty {
                    
                    // add categories into search terms
                    for category in activeCategories {
                        let categoryTerms = category.lowercased().split(separator: " ").map(String.init)
                        for term in categoryTerms {
                            searchTerms.append(term)
                        }
                    }
                }
                
                let trimmedSearchTerms = searchTerms.map { $0.trimmingCharacters(in: .whitespaces) }
                
                // make the call
                do {
                    var courseQuery = db.collection("courses").whereField("searchTerms", arrayContainsAny: trimmedSearchTerms)
                    
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
                    
                    let courseSnapshot = try await courseQuery.limit(to: 1).start(afterDocument: lastDocCourse).getDocuments()
                    
                    if courseSnapshot.documents.isEmpty { noCoursesLeftToLoad = true }
                    
                    self.searchResultCourses.append(contentsOf: courseSnapshot.documents.compactMap { document -> Course? in
                        let course = try? document.data(as: Course.self)
                        
                        if let course = course, let courseId = course.id, let channelId = course.channelId {
                            courseController.cachedCourses[courseId] = course
                            
                            courseController.getCourseThumbnail(courseId: courseId)
                            
                            courseController.retrieveChannel(channelId: channelId)
                        } else {
                            print("course was nil")
                        }
                        return course
                    })
                    
                    // get the last doc for pagination
                    guard let lastDocument = courseSnapshot.documents.last else {
                        // the collection is empty
                        return
                    }
                    
                    self.lastDocCourse = lastDocument
                    
                } catch let error {
                    print("error")
                }
            }
        }
    }
    
    func getMoreLectures(courseController: CourseController) {
        // return early if last doc isn't populated
        if let lastDocLecture = self.lastDocLecture {
            Task { @MainActor in
                // build search terms
                var searchTerms = searchText.lowercased().split(separator: " ").map(String.init)
                
                if !activeCategories.isEmpty {
                    
                    // add categories into search terms
                    for category in activeCategories {
                        let categoryTerms = category.lowercased().split(separator: " ").map(String.init)
                        for term in categoryTerms {
                            searchTerms.append(term)
                        }
                    }
                }
                
                let trimmedSearchTerms = searchTerms.map { $0.trimmingCharacters(in: .whitespaces) }
                
                do {
                    var lectureQuery = db.collection("lectures").whereField("searchTerms", arrayContainsAny: trimmedSearchTerms)
                    
                    // for lectures, we'd prefer to show results for the earliest lecture in the course if possible, so let's try to order them by that field
                    lectureQuery = lectureQuery.order(by: "lectureNumberInCourse")
                    
//                    // Apply sorting
                    if sortByMostWatched {
                        // TODO: switch views on Youtube to an int, rn it's a string
                        lectureQuery = lectureQuery.order(by: "viewsOnYouTube", descending: true)
                    } else if sortByMostLiked {
                        lectureQuery = lectureQuery.order(by: "numLikesInApp", descending: true)
                    }
                    
                    
                    let lectureSnapshot = try await lectureQuery.limit(to: 1).start(afterDocument: lastDocLecture).getDocuments()
                    
                    if lectureSnapshot.documents.isEmpty { noLecturesLeftToLoad = true }
                    
                    
                    self.searchResultLectures.append(contentsOf: lectureSnapshot.documents.compactMap { document -> Lecture? in
                        let lecture = try? document.data(as: Lecture.self)
                        
                        if let lecture = lecture, let lectureId = lecture.id, let channelId = lecture.channelId {
                            courseController.cachedLectures[lectureId] = lecture
                            
                            courseController.getLectureThumnbnail(lectureId: lectureId)
                            
                            courseController.retrieveChannel(channelId: channelId)
                        } else {
                            print("lecture was nil")
                        }
                        return lecture
                    })
                    
                    // get the last doc for pagination
                    guard let lastLectureDocument = lectureSnapshot.documents.last else {
                        // the collection is empty
                        return
                    }
                    
                    self.lastDocLecture = lastLectureDocument
                    
                } catch  {
                    print("error")
                }
            }
        }
    }
}
