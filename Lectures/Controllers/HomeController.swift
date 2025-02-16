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
    
    // Content for the for you page
    @Published var leadingUniversities: [Channel] = []
    @Published var curatedCourses: [Course] = []
    @Published var communityFavorites: [Course] = []
    // loading vars for the home page content
    @Published var isUniversityLoading: Bool = false
    @Published var isCuratedCoursesLoading: Bool = false
    @Published var isCommunityFavoritesLoading: Bool = false
    
    let tabs = ["Computer Science", "Business", "Engineering", "Humanities", "Math", "Health"]
    
    @Published var coursesForYouPerTab: [String: [Course]] = [:]
    @Published var leadingChannelsPerTab: [String: [Channel]] = [:]
    @Published var famousCoursesPerTab: [String: [Course]] = [:]
    // loading vars
    @Published var isCoursesForYouLoading: Bool = false
    @Published var isLeadingChannelsLoading: Bool = false
    @Published var isFamousCoursesLoading: Bool = false
    
    var courseForYouIdsByTab: [String : [String]] = [:]
    var leadingChannelIdsByTab: [String : [String]] = [:]
    
    // Firestore
    let db = Firestore.firestore()
    // Storage
    let storage = Storage.storage()
    
    
    init() {
        courseForYouIdsByTab["Computer Science"] = ["385", "537", "533", "544", "885", "958", "419", "547", "917", "550", "538", "549", "927", "462", "956", "539", "952", "548", "948", "565", "955", "926", "965", "465", "553", "950", "951", "551", "961"]
        courseForYouIdsByTab["Business"] = ["424", "448", "1157", "445", "433", "1126", "434", "1127", "450", "439", "1164"]
        courseForYouIdsByTab["Engineering"] = ["416", "579", "597", "580", "921", "885", "500", "907", "1134", "478", "529", "883", "535", "979", "895", "249", "526", "886", "566", "525", "417", "576", "882", "582", "541"]
        courseForYouIdsByTab["Humanities"] = ["9", "909", "1116", "424", "1155", "1148", "1166", "1163", "1157", "1150", "1117", "595", "844", "1149", "1139", "1152", "1118", "389", "1147", "99", "1160", "1162", "845", "1136", "1122", "319", "1161", "101", "313", "1159", "1129", "33"]
        courseForYouIdsByTab["Math"] = ["463", "461", "824", "474", "828", "827", "455", "616", "544", "456", "547", "836", "459", "546", "835", "547", "829", "391", "458", "423", "471", "462", "752", "422", "736", "548", "830", "918", "599", "601", "421", "726"]
        courseForYouIdsByTab["Health"] = ["909", "597", "1148", "1117", "844", "842", "577", "389", "919", "576", "313", "33", "841", "1124", "360", "572", "32", "840", "575", "574"]
        
        leadingChannelIdsByTab["Computer Science"] = ["26", "9", "15", "27", "4"]
        leadingChannelIdsByTab["Business"] = ["5", "7", "19", "27", "36"]
        leadingChannelIdsByTab["Engineering"] = ["3", "4", "9", "15", "26", "27"]
        leadingChannelIdsByTab["Humanities"] = ["5", "19", "24", "34", "36", "2", "11"]
        leadingChannelIdsByTab["Math"] = ["18", "15", "3", "26", "30", "33"]
        leadingChannelIdsByTab["Health"] = ["10", "12", "11", "19", "26", "33"]
        
        
    }
    
    // MARK: - For You Functions
    func retrieveLeadingUniversities(courseController: CourseController) {
        // IDs = [harvard, mit open courseware, oxford math, stanford , yale courses]
        let channelIds = ["9", "15", "18", "26", "36"]
        
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
        // This function will select 5 random courses from this list of curated course
        // courseids = [533, 388, 824, 424, 537, 597, 580, 1135, 445, 419, 1150, 547, 917, 1134, 1139]
        
        
        // TODO: make this list curated, not just the top from the db
        Task { @MainActor in
            let courseids = ["533", "388", "824", "424", "537", "597", "580", "1135", "445", "419", "1150", "547", "917", "1134", "1139", "474", "579", "448", "827", "921", "1155", "616"]
            // Randomly select 6 course IDs
            let selectedCourseIds = Array(courseids.shuffled().prefix(6))
            
            do {
                for courseId in selectedCourseIds {
                    let docRef = db.collection("courses").document(courseId)
                    
                    do {
                        let course = try await docRef.getDocument(as: Course.self)
                        self.curatedCourses.append(course)
                        
                        // add the course to the cache
                        courseController.cachedCourses[courseId] = course
                        
                        // fetch the courses thumbnail
                        courseController.getCourseThumbnail(courseId: courseId)
                        
                        // fetch the channel
                        if let channelId = course.channelId {
                            courseController.retrieveChannel(channelId: channelId)
                        }
                    } catch {
                        print("Error decoding course \(courseId): \(error)")
                    }
                }
                
                self.isCuratedCoursesLoading = false
            }
        }
    }
    
    func retrieveCommunityFavorites(courseController: CourseController) {
        
        // get the courses with the most likes from the courses column in Firebase
        self.communityFavorites = []
        
        Task { @MainActor in
            do {
                let querySnapshot = try await db.collection("courses")
                    .order(by: "aggregateViews", descending: true)
                    .limit(to: 5)
                    .getDocuments()
                
                if querySnapshot.isEmpty {
                    print("no courses returned when looking up community favorites")
                    self.isCommunityFavoritesLoading = false
                    return
                }
                
                for document in querySnapshot.documents {
                    if let course = try? document.data(as: Course.self) {
                        
                        self.communityFavorites.append(course)
                        
                        if let courseId = course.id {
                            // add the course to the cache
                            courseController.cachedCourses[courseId] = course
                            
                            // fetch the courses thumbnail
                            courseController.getCourseThumbnail(courseId: courseId)
                            
                            // fetch the channel
                            if let channelId = course.channelId {
                                courseController.retrieveChannel(channelId: channelId)
                            }
                        }
                    }
                }
                
                self.isCommunityFavoritesLoading = false
            } catch let error {
                print("error getting community favorites from firestore: ", error)
            }
        }
    }
    
    // MARK: - Functions per tab
    func retrieveCoursesForYouByTab(tabName: String, courseController: CourseController) {
        // Check if we already have courses for this tab
        if let existingCourses = self.coursesForYouPerTab[tabName], !existingCourses.isEmpty {
            return
        }
        
        self.isCoursesForYouLoading = true
        
        var courseIds: [String] = []
        switch tabName {
        case "Computer Science":
            courseIds = Array((courseForYouIdsByTab["Computer Science"] ?? []).shuffled().prefix(6))
        case "Business":
            courseIds = Array((courseForYouIdsByTab["Business"] ?? []).shuffled().prefix(6))
        case "Engineering":
            courseIds = Array((courseForYouIdsByTab["Engineering"] ?? []).shuffled().prefix(6))
        case "Humanities":
            courseIds = Array((courseForYouIdsByTab["Humanities"] ?? []).shuffled().prefix(6))
        case "Math":
            courseIds = Array((courseForYouIdsByTab["Math"] ?? []).shuffled().prefix(6))
        case "Health":
            courseIds = Array((courseForYouIdsByTab["Health"] ?? []).shuffled().prefix(6))
        default:
            print("Unknown tab: \(tabName)")
            return
        }
        
        Task { @MainActor in
            // Initialize empty array for this tab if it doesn't exist
            self.coursesForYouPerTab[tabName] = []
            
            do {
                for courseId in courseIds {
                    // Check if course is already cached
                    if let cachedCourse = courseController.cachedCourses[courseId] {
                        self.coursesForYouPerTab[tabName]?.append(cachedCourse)
                        continue
                    }
                    
                    let docRef = db.collection("courses").document(courseId)
                    
                    do {
                        let course = try await docRef.getDocument(as: Course.self)
                        self.coursesForYouPerTab[tabName]?.append(course)
                        
                        // add the course to the cache
                        courseController.cachedCourses[courseId] = course
                        
                        // fetch the courses thumbnail
                        courseController.getCourseThumbnail(courseId: courseId)
                        
                        // fetch the channel
                        if let channelId = course.channelId {
                            courseController.retrieveChannel(channelId: channelId)
                        }
                    } catch {
                        print("Error decoding course \(courseId): \(error)")
                    }
                }
                
                self.isCoursesForYouLoading = false
            }
        }
    }
    
    func retrieveLeadingChannelsPerTab(tabName: String, courseController: CourseController) {
        // Check if we already have channels for this tab
        if let existingChannels = self.leadingChannelsPerTab[tabName], !existingChannels.isEmpty {
            return
        }
        
        self.isLeadingChannelsLoading = true
        
        var channelIds: [String] = []
        switch tabName {
        case "Computer Science":
            channelIds = Array((leadingChannelIdsByTab["Computer Science"] ?? []).shuffled().prefix(6))
        case "Business":
            channelIds = Array((leadingChannelIdsByTab["Business"] ?? []).shuffled().prefix(6))
        case "Engineering":
            channelIds = Array((leadingChannelIdsByTab["Engineering"] ?? []).shuffled().prefix(6))
        case "Humanities":
            channelIds = Array((leadingChannelIdsByTab["Humanities"] ?? []).shuffled().prefix(6))
        case "Math":
            channelIds = Array((leadingChannelIdsByTab["Math"] ?? []).shuffled().prefix(6))
        case "Health":
            channelIds = Array((leadingChannelIdsByTab["Health"] ?? []).shuffled().prefix(6))
        default:
            print("Unknown tab: \(tabName)")
            return
        }
        
        Task { @MainActor in
            // Initialize empty array for this tab if it doesn't exist
            self.leadingChannelsPerTab[tabName] = []
            
            do {
                for channelId in channelIds {
                    // Check if channel is already cached
                    if let cachedChannel = courseController.cachedChannels[channelId] {
                        self.leadingChannelsPerTab[tabName]?.append(cachedChannel)
                        continue
                    }
                    
                    let docRef = db.collection("channels").document(channelId)
                    
                    do {
                        let channel = try await docRef.getDocument(as: Channel.self)
                        self.leadingChannelsPerTab[tabName]?.append(channel)
                        
                        // cache the fetched channel
                        courseController.cachedChannels[channelId] = channel
                        
                        // get the thumbnail for the channel
                        courseController.getChannelThumbnail(channelId: channelId)
                        
                    } catch {
                        print("Error decoding channel \(channelId): \(error)")
                    }
                }
                
                self.isLeadingChannelsLoading = false
            }
        }
    }
    
    func retrieveFamousCoursePerTab(tabName: String, courseController: CourseController) {
        // Check if we already have courses for this tab
        if let existingCourses = self.famousCoursesPerTab[tabName], !existingCourses.isEmpty {
            return
        }
        
        self.isFamousCoursesLoading = true
        
        var searchTerms: [String] = []
        switch tabName {
        case "Computer Science":
            searchTerms = ["computer", "programming", "software", "coding", "algorithm", "data structure", "artificial intelligence", "machine learning", "computer vision", "natural language processing", "computer networks", "operating systems", "database", "computer architecture", "computer organization", "computer graphics", "computer security", "computer networks", "operating systems", "database", "computer architecture", "computer organization", "computer graphics", "computer security"]
        case "Business":
            searchTerms = ["business", "finance", "economics", "management", "marketing", "entrepreneurship", "accounting", "finance", "economics", "management", "marketing", "entrepreneurship", "accounting", "finance", "economics", "management", "marketing", "entrepreneurship", "accounting", "finance", "economics", "management", "marketing", "entrepreneurship", "accounting"]
        case "Engineering":
            searchTerms = ["engineering", "mechanical", "electrical", "civil", "chemical", "materials", "biomedical", "environmental", "physics", "thermodynamics", "fluid mechanics", "structural engineering", "control systems", "robotics", "power systems", "electronics", "circuits", "manufacturing", "aerodynamics", "heat transfer", "mechanics", "dynamics", "statics", "materials science"]
        case "Humanities":
            searchTerms = ["history", "philosophy", "literature", "arts", "music", "film", "theater", "dance", "literature", "arts", "music", "film", "theater", "dance"]
        case "Math":
            searchTerms = ["mathematics", "calculus", "algebra", "statistics", "geometry", "trigonometry", "algebra", "statistics", "geometry", "trigonometry"]
        case "Health":
            searchTerms = ["health", "medical", "biology", "medicine", "nutrition", "fitness", "nutrition", "fitness", "nutrition", "fitness", "nutrition", "fitness", "nutrition", "fitness", "nutrition", "fitness", "nutrition", "fitness", "nutrition", "fitness"]
        default:
            print("Unknown tab: \(tabName)")
            return
        }
        
        Task { @MainActor in
            // Initialize empty array for this tab if it doesn't exist
            self.famousCoursesPerTab[tabName] = []
            
            do {
                let querySnapshot = try await db.collection("courses")
                    .whereField("searchTerms", arrayContainsAny: searchTerms)
                    .order(by: "aggregateViews", descending: true)
                    .limit(to: 6)
                    .getDocuments()
                
                if querySnapshot.isEmpty {
                    print("No famous courses found for tab: \(tabName)")
                    self.isFamousCoursesLoading = false
                    return
                }
                
                for document in querySnapshot.documents {
                    if let course = try? document.data(as: Course.self) {
                        self.famousCoursesPerTab[tabName]?.append(course)
                        
                        if let courseId = course.id {
                            // add the course to the cache
                            courseController.cachedCourses[courseId] = course
                            
                            // fetch the courses thumbnail
                            courseController.getCourseThumbnail(courseId: courseId)
                            
                            // fetch the channel
                            if let channelId = course.channelId {
                                courseController.retrieveChannel(channelId: channelId)
                            }
                        }
                    }
                }
                
                self.isFamousCoursesLoading = false
            } catch {
                print("Error retrieving famous courses for \(tabName): \(error)")
                self.isFamousCoursesLoading = false
            }
        }
    }
}
