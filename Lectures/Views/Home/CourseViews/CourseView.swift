//
//  CourseView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI

struct CourseView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var isCourseLiked: Bool = false
    var body: some View {
        VStack {
            // Course Cover Image
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack {
                        // course Image
                        Image("stanford")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 40, height: 40)
                        
                        // Course title and University
                        VStack {
                            Text("The Emotion Machine")
                                .font(.system(size: 18, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Stanford University")
                                .font(.system(size: 12, design: .serif))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Save button
                        if !isCourseLiked {
                            Image(systemName: "heart")
                                .font(.system(size: 18, design: .serif))
                                .onTapGesture {
                                    self.isCourseLiked.toggle()
                                }
                        } else {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 18, design: .serif))
                                .foregroundStyle(Color.red)
                                .onTapGesture {
                                    self.isCourseLiked.toggle()
                                }
                        }
                    }
                    
                    // Course Info
                    HStack {
                        Text("6 Lectures")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                        
                        Text("9Hr Watch Time")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                        
                        Text("50M Views")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                        Spacer()
                    }
                    
                    // Course Categories
                    HStack {
                        Text("Neruoscience")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                        
                        Text("Computer Science")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.6)
                        Spacer()
                    }
                    
                    
                    // Notes
                    HStack {
                        Text("Exam")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.blue)
                            .font(.system(size: 14, design: .serif))
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.clear)
                        .frame(minWidth: 200)
                        .frame(height: 30)
                        .overlay {
                            HStack {
                                Image(systemName: "doc.circle")
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                
                                Text("The Emotion Machine - Course Exam")
                                    .font(.system(size: 12, design: .serif))
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    
                    // Notes
                    HStack {
                        Text("Exam Answers")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.blue)
                            .font(.system(size: 14, design: .serif))
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.clear)
                        .frame(minWidth: 200)
                        .frame(height: 30)
                        .overlay {
                            HStack {
                                Image(systemName: "doc.circle")
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                
                                Text("The Emotion Machine - Course Exam Answer Guide")
                                    .font(.system(size: 12, design: .serif))
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    
                    LecturesInCourse()
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    
                    Divider()
                    
                    
                    // Related Courses
                    HStack {
                        Text("Related to")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        
                        Text("The Emotion Machine")
                            .font(.system(size: 14, design: .serif))
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                
                SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "Swaginomics", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                
                SearchedCourse(coverImage: "stanford", universityImage: "mit", courseName: "How to pull", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                
                SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "Another One For Ya", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
            }
        }
    }
}

#Preview {
    CourseView()
}
