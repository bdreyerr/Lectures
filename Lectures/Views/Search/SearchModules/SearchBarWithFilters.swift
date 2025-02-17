//
//  SearchBarWithFilters.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/28/24.
//

import SwiftUI

struct SearchBarWithFilters: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var rateLimiter: RateLimiter
    
    @EnvironmentObject var searchController: SearchController
    @EnvironmentObject var courseController: CourseController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @State var isUpgradeAccountPopupShowing: Bool = false
    
    var accountType: Int?
    var body: some View {
        VStack {
            HStack {
                // Search Icon
                Image(systemName: "magnifyingglass")
                
                // Search TextField
                TextField("Search", text: $searchController.searchText)
                    .font(.system(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
                    .onSubmit {
                        if let rateLimit = rateLimiter.processWrite() {
                            print(rateLimit)
                            return
                        }
                        
                        searchController.areFiltersShowing = false
                        searchController.performSearch(courseController: courseController)
                        hideKeyboard()
                    }
                
                
                // Clear Button (X Icon)
                if !searchController.searchText.isEmpty {
                    Button(action: {
                        searchController.searchText = "" // Clear the text
                        searchController.clearSearchResults()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 10)
                }
                    
                
                // Submit search Button
                if !searchController.searchText.isEmpty {
                    Button(action: {
                        if let rateLimit = rateLimiter.processWrite() {
                            print(rateLimit)
                            return
                        }
                        
                        searchController.areFiltersShowing = false
                        searchController.performSearch(courseController: courseController)
                        hideKeyboard()
                        
                    }) {
                        Image(systemName: "arrow.forward.circle.fill")
                            .foregroundStyle(Color.green)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.trailing, 10)
                }
                
                // filters
                Button(action: {
                    withAnimation(.spring()) {
                        searchController.areFiltersShowing.toggle()
                    }
                }) {
                    Image(systemName: "text.alignright")
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            if searchController.areFiltersShowing {
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
                        
                        FilterSearchResultType(accountType: accountType)
                        
                        
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
                            ForEach(searchController.categoryList, id: \.self) { category in
                                if let accountType = accountType {
                                    CategoryFilterPill(text: category, accountType: accountType)
                                } else {
                                    CategoryFilterPill(text: category)
                                }
                            }
                            
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
                        PlainSearchFilterPill(text: "<5 lecture", isSelected: $searchController.lessThanFiveLectures, onTap: { isSelected in
                            if !subscriptionController.isPro {
                                isUpgradeAccountPopupShowing = true
                            } else {
                                if isSelected {
                                    searchController.lessThanFiveLectures = false
                                } else {
                                    searchController.lessThanFiveLectures = true
                                    searchController.greaterThanFiveLectures = false
                                    searchController.greaterThanTenLectures = false
                                }
                            }
                        })
                        
                        
                        PlainSearchFilterPill(text: ">5 lecture", isSelected: $searchController.greaterThanFiveLectures, onTap: { isSelected in
                            if !subscriptionController.isPro {
                                isUpgradeAccountPopupShowing = true
                            } else {
                                if isSelected {
                                    searchController.greaterThanFiveLectures = false
                                } else {
                                    searchController.lessThanFiveLectures = false
                                    searchController.greaterThanFiveLectures = true
                                    searchController.greaterThanTenLectures = false
                                }
                            }
                        })
                        PlainSearchFilterPill(text: ">10 lecture", isSelected: $searchController.greaterThanTenLectures, onTap: { isSelected in
                            if !subscriptionController.isPro {
                                isUpgradeAccountPopupShowing = true
                            } else {
                                if isSelected {
                                    searchController.greaterThanTenLectures = false
                                } else {
                                    searchController.lessThanFiveLectures = false
                                    searchController.greaterThanFiveLectures = false
                                    searchController.greaterThanTenLectures = true
                                }
                            }
                        })
                        
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
                        PlainSearchFilterPill(text: "Most Watched", isSelected: $searchController.sortByMostWatched, onTap: { isSelected in
                            if !subscriptionController.isPro {
                                isUpgradeAccountPopupShowing = true
                            } else {
                                if !isSelected {
                                    searchController.sortByMostWatched = true
                                    searchController.sortByMostLiked = false
                                }
                            }
                        })
                        
//                        PlainSearchFilterPill(text: "Most Liked", isSelected: $searchController.sortByMostLiked, onTap: { isSelected in
//                            if let accountType = accountType {
//                                if accountType == 0 {
//                                    isUpgradeAccountPopupShowing = true
//                                } else {
//                                    if !isSelected {
//                                        searchController.sortByMostWatched = false
//                                        searchController.sortByMostLiked = true
//                                    }
//                                }
//                            }
//                        })
                        
                        Spacer()
                    }
                }
                
                
            }
        }
        .padding(10)
        .background(colorScheme == .light ? Color.black.opacity(0.05) : Color.white.opacity(0.2))
        .cornerRadius(20) // Rounded corners
        .padding(.top, 10)
        .sheet(isPresented: $isUpgradeAccountPopupShowing) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $isUpgradeAccountPopupShowing)
        }
        
    }
}

#Preview {
    SearchBarWithFilters()
}
