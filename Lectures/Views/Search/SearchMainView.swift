//
//  SearchMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/18/24.
//

import SwiftUI

struct SearchMainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText: String = ""
    @State private var areFiltersShowing: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                TopBrandView()
                    .padding(.horizontal, 20)
                
                
                ScrollView() {
                    
                    VStack {
                        HStack {
                            // Search Icon
                            Image(systemName: "magnifyingglass")
                            
                            // Search TextField
                            TextField("Search", text: $searchText)
                                .font(.system(size: 16))
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            
                            // Clear Button (X Icon)
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = "" // Clear the text
                                }) {
                                    Image(systemName: "xmark")
                                }
                            }
                            
                            // filters
                            Button(action: {
                                withAnimation(.spring()) {
                                    areFiltersShowing.toggle()
                                }
                            }) {
                                Image(systemName: "text.alignright")
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        if areFiltersShowing {
                            // Result Type
                            // Categories
                            Group {
                                HStack {
                                    Text("Result Type")
                                        .font(.system(size: 12))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                
                                HStack {
                                    SearchResultTypePill(iconName: "newspaper.fill", text: "Lectures")
                                    
                                    SearchResultTypePill(iconName: "mail.stack.fill", text: "Courses")
                                    
                                    SearchResultTypePill(iconName: "graduationcap", text: "Channels")
                                    
                                    Spacer()
                                }
                            }
                            
                            // Categories
                            Group {
                                HStack {
                                    Text("Categories")
                                        .font(.system(size: 12))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        PlainSearchFilterPill(text: "Computer Science")
                                        
                                        PlainSearchFilterPill(text: "Business")
                                        
                                        PlainSearchFilterPill(text: "Health")
                                        
                                        Spacer()
                                    }
                                }
                            }
                            
                            
                            // Course Size (selecting any of these removes lectures from search results)
                            Group {
                                HStack {
                                    Text("Course Size")
                                        .font(.system(size: 12))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                
                                HStack {
                                    PlainSearchFilterPill(text: "<5 lecture")
                                    PlainSearchFilterPill(text: ">5 lecture")
                                    PlainSearchFilterPill(text: ">105 lecture")
                                    
                                    Spacer()
                                }
                            }
                            
                            
                            // Sory By
                            Group {
                                HStack {
                                    Text("Sory By")
                                        .font(.system(size: 12))
                                    Spacer()
                                }
                                .padding(.top, 10)
                                
                                HStack {
                                    PlainSearchFilterPill(text: "Most Watched")
                                    PlainSearchFilterPill(text: "Most Liked")
                                    
                                    Spacer()
                                }
                            }
                            
                            
                        }
                    }
                    .padding(10)
                    .background(Color.black.opacity(0.05)) // Dark background
                    .cornerRadius(20) // Rounded corners
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    
                    //                    HStack {
                    //                        Text("Find a course -")
                    //                            .font(.system(size: 20, design: .serif))
                    //                            .bold()
                    //                            .padding(.bottom, 2)
                    //
                    //                        Spacer()
                    //
                    //                        // Replace previous Text with this version
                    //                        Text(displayedText)
                    //                            .font(.system(size: 18, design: .serif))
                    //                            .frame(maxWidth: .infinity, alignment: .leading)
                    //                            .foregroundColor(.black.opacity(0.9))
                    //                            .animation(.easeInOut(duration: 0.1), value: displayedText)
                    //                            .onReceive(timer) { _ in
                    //                                if !isAnimating {
                    //                                    currentIndex = (currentIndex + 1) % subjects.count
                    //                                    currentSubject = subjects[currentIndex]
                    //                                    typeWriter()
                    //                                }
                    //                            }
                    //                            .onAppear {
                    //                                typeWriter() // Initial animation
                    //                            }
                    //                    }
                    //                    .padding(.horizontal, 20)
                    
                    //                    SearchBarWithFilters()
                    //                        .padding(.horizontal, 20)
                    //                        .padding(.bottom, 10)
                    
                    //                    SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "The Emotion Machine", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    //
                    //                    SearchedCourse(coverImage: "stanford", universityImage: "mit", courseName: "The Emotion Machine", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    //
                    //                    SearchedCourse(coverImage: "mit", universityImage: "stanford", courseName: "Another One For Ya", universityName: "MIT", numLectures: 6, watchTimeinHrs: 9, totalViews: "50M")
                    
                }
                
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .navigationBarHidden(true)
    }
}

// Add this helper view for filter chips
struct FilterChip: View {
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 12, design: .serif))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.black : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.black, lineWidth: 0.5)
            )
            .onTapGesture {
                isSelected.toggle()
            }
    }
}

#Preview {
    SearchMainView()
}
