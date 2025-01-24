//
//  FullCollectionView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/12/25.
//

import SwiftUI

struct FullCollectionView: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var collection: Collection
    
    var body: some View {
        if let image = collection.image, let title = collection.title, let subText = collection.subText, let courseIdList = collection.courseIdList, let description = collection.description {
            VStack {
                ScrollView(showsIndicators: false) {
                    // Collection Title
                    HStack {
                        Image(image)
                            .resizable()
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                        
                        VStack {
                            HStack {
                                Text(title)
                                    .font(.system(size: 16, design: .serif))
                                    .fontWeight(.bold)
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text(subText)
                                    .font(.system(size: 12, design: .serif))
                                    .opacity(0.8)
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .cornerRadius(5)
                    .padding(.bottom, 10)
                    
                    // Collection Description
                    ExpandableText(text: description, maxLength: 250)
                        .padding(.bottom, 10)
                    
                    // Course list for the collection
                    ForEach(courseIdList, id: \.self) { courseId in
                        if let course = courseController.cachedCourses[courseId] {
                            CourseInCollection(course: course)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    FullCollectionView(collection: Collection())
        .environmentObject(HomeController())
}
