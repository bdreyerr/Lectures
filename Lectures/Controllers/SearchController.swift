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
        
        self.wasSearchPerformed = false
    }
    
    func performSearch(courseController: CourseController) {
        Task { @MainActor in
            guard searchText.count >= 2 else {
                searchResultCourses = []
                searchResultLectures = []
                searchResultChannels = []
                return
            }
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
                    
                    let snapshot = try await courseQuery.limit(to: 8).getDocuments()
                    
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
                    
                    
                    
                    
                    let snapshot = try await lectureQuery.limit(to: 8).getDocuments()
                    
                    self.searchResultLectures = snapshot.documents.compactMap { document -> Lecture? in
                        let lecture = try? document.data(as: Lecture.self)
                        
                        if let lecture = lecture {
                            courseController.cachedLectures[lecture.id!] = lecture
                            
                            courseController.getLectureThumnbnail(lectureId: lecture.id!)
                            
                            courseController.retrieveChannel(channelId: lecture.channelId!)
                        } else {
                            print("lecture was nil")
                        }
                        return lecture
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
                    
                    let snapshot = try await channelQuery.limit(to: 8).getDocuments()
                    
                    self.searchResultChannels = snapshot.documents.compactMap { document -> Channel? in
                        let channel = try? document.data(as: Channel.self)
                        
                        if let channel = channel {
                            courseController.cachedChannels[channel.id!] = channel
                            
                            courseController.getChannelThumbnail(channelId: channel.id ?? "0")
                        }
                        
                        return channel
                    }
                } catch let error {
                    print("error searching channels: ", error.localizedDescription)
                }
            }
            
            self.wasSearchPerformed = true
        }
    }
}
