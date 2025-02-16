//
//  TabAbout.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import FirebaseFirestore
import SwiftUI

struct TabAbout: View {
    var course: Course
    var lecture: Lecture?
    
    var body: some View {
        if let courseTitle = course.courseTitle,
           let numLecturesInCourse = course.numLecturesInCourse,
           let watchTimeInHrs = course.watchTimeInHrs,
           let aggregateViews = course.aggregateViews,
           let courseDescription = course.courseDescription,
           let professorName = course.professorName {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Course Information Section
                    CourseInfoSection(
                        courseTitle: courseTitle,
                        numLectures: numLecturesInCourse,
                        watchTime: watchTimeInHrs,
                        views: aggregateViews,
                        description: courseDescription,
                        professorName: professorName
                    )
                    
                    // Current Lecture Section (if available)
                    if let lecture = lecture {
                        CurrentLectureSection(lecture: lecture)
                    }
                    
                    RecommendedCoursesSection(course: course)
                }
                .padding(.vertical)
            }
        }
    }
}

// MARK: - Course Information Section
private struct CourseInfoSection: View {
    let courseTitle: String
    let numLectures: Int
    let watchTime: Int
    let views: Int
    let description: String
    let professorName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("Course Information")
                .font(.title2)
                .fontWeight(.bold)
            
            // Title
            Text(courseTitle)
                .font(.system(size: 18, design: .serif))
            
            if professorName != "" {
                HStack(spacing: 4) {
                    Text("Taught by:")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .italic()
                    
                    Text(professorName)
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                }
            }
                
            
            // Stats Row
            HStack(spacing: 16) {
                StatItem(icon: "play.circle", text: "\(numLectures) Lectures")
                StatItem(icon: "clock", text: "\(watchTime)hr Watch Time")
                StatItem(icon: "eye", text: "\(formatIntViewsToString(numViews: views)) Views")
            }
            
            // Description
            VStack(alignment: .leading, spacing: 4) {
                Text("About this course")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                ExpandableText(
                    text: description.isEmpty ? "We couldn't find a description for this course" : description,
                    maxLength: 150
                )
            }
        }
    }
}

// MARK: - Current Lecture Section
private struct CurrentLectureSection: View {
    let lecture: Lecture
    
    var body: some View {
        if let lectureTitle = lecture.lectureTitle,
           let professorName = lecture.professorName,
           let lectureDescription = lecture.lectureDescription,
           let viewsOnYouTube = lecture.viewsOnYouTube,
           let datePostedonYoutube = lecture.datePostedonYoutube {
            
            VStack(alignment: .leading, spacing: 12) {
                // Header
                Text("Current Lecture")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Lecture Title
                Text(lectureTitle)
                    .font(.system(size: 18, design: .serif))
                
                // Professor
                if professorName != "" {
                    HStack(spacing: 4) {
                        Text("Taught by:")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .italic()
                        
                        Text(professorName)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                    }
                }
                
                // Stats Row
                HStack(spacing: 16) {
                    StatItem(icon: "eye", text: "\(formatIntViewsToString(numViews: viewsOnYouTube)) Views")
                    StatItem(icon: "calendar", text: datePostedonYoutube)
                }

                // Description
                ExpandableText(
                    text: lectureDescription.isEmpty ? "We couldn't find a description for this lecture" : lectureDescription,
                    maxLength: 150
                )
            }
        }
    }
}

// MARK: - Recommended Course Section
private struct RecommendedCoursesSection: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    @EnvironmentObject var courseController: CourseController
    
    var course: Course
    
    @State private var isSignInSheetShowing: Bool = false
    @State private var isUpgradeAccountSheetShowing: Bool = false
    
    @State private var localCourseRecommendations: [Course] = []
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recommended Courses")
                .font(.title2)
                .fontWeight(.bold)
            
            if !isSignedIn {
                VStack(alignment: .center) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("Logged in users have access to course recommendations")
                        .font(.system(size: 13, design: .serif))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        isSignInSheetShowing = true
                    }) {
                        Text("Sign Up / Sign In")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                if !subscriptionController.isPro {
                    VStack(alignment: .center) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.gray.opacity(0.3))
                            .padding(.top, 40)
                        
                        Text("Pro users have access to course recommendations")
                            .font(.system(size: 13, design: .serif))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            isUpgradeAccountSheetShowing = true
                        }) {
                            Text("Upgrade")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.orange.opacity(0.8))
                                .cornerRadius(20)
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    
                    ForEach(self.localCourseRecommendations, id: \.id) { course in
                        RelatedCourse(course: course)
                    }
                    
                    // Skeleton Loader
//                    if courseController.isRelatedCourseLoading {
//                        VStack {
//                            HStack {
//                                SkeletonLoader(width: 350, height: 60)
//                                Spacer()
//                            }
//                            HStack {
//                                SkeletonLoader(width: 350, height: 60)
//                                Spacer()
//                            }
//                            HStack {
//                                SkeletonLoader(width: 350, height: 60)
//                                Spacer()
//                            }
//                        }
//                    } else {
//                        ForEach(self.localCourseRecommendations, id: \.id) { course in
//                            RelatedCourse(course: course)
//                        }
//                    }
                }
            }
        }
        .onAppear {
            // get a local version of courseRecommendations, so we don't get dragged back to the view when going to another nav link
            if self.localCourseRecommendations.isEmpty {
                self.localCourseRecommendations = courseController.courseRecommendations
            }
        }
        .sheet(isPresented: $isSignInSheetShowing) {
            FirstOpenSignUpSheet(text: "Sign In", displaySheet: $isSignInSheetShowing)
                .presentationDetents([.fraction(0.25), .medium]) // User can drag between these heights
        }
        .sheet(isPresented: $isUpgradeAccountSheetShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountSheetShowing)
        }
    }
}

// MARK: - Helper Views
private struct StatItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(text)
                .font(.system(size: 11))
        }
        .foregroundColor(.secondary)
    }
}

func formatIntViewsToString(numViews: Int) -> String {
    switch numViews {
    case 0..<1_000:
        return String(numViews)
    case 1_000..<1_000_000:
        let thousands = Double(numViews) / 1_000.0
        return String(format: "%.0fk", thousands)
    case 1_000_000...:
        let millions = Double(numViews) / 1_000_000.0
        return String(format: "%.0fM", millions)
    default:
        return "0"
    }
}

//#Preview {
//    TabAbout()
//}
