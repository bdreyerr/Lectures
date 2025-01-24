//
//  CollectionCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/12/25.
//

import SwiftUI

struct CollectionCard : View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    var collection: Collection
    
    var body: some View {
        if let image = collection.image, let title = collection.title, let subText = collection.subText, let courseIdList = collection.courseIdList {
            
            NavigationLink(destination: FullCollectionView(collection: collection)) {
                
                
                // Collection Title
                HStack {
                    Image(image)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fill)
                    
                    VStack {
                        HStack {
                            Text(title)
                                .font(.system(size: 14, design: .serif))
                            
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
            }
            .simultaneousGesture(TapGesture().onEnded { _ in
                // retrieve the courses in this collection
                for courseId in courseIdList {
                    courseController.retrieveCourse(courseId: courseId)
                }
            })
            .buttonStyle(PlainButtonStyle())
        }

    }
}

//#Preview {
//    CollectionCard()
//}
