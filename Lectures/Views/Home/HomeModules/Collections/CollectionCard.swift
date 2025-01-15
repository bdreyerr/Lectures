//
//  CollectionCard.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/12/25.
//

import SwiftUI

struct CollectionCard : View {
    @EnvironmentObject var homeController: HomeController
    var collection: Collection
    
    var body: some View {
        NavigationLink(destination: FullCollectionView(collection: collection)) {
            ZStack(alignment: .bottomLeading) {
                Image(collection.image!)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Add semi-transparent gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.75)]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(collection.title!)
                                .font(.system(size: 16, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack {
                                Text(collection.subText!)
                                    .font(.system(size: 12, design: .serif))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            
                        }
                        Spacer()
                    }
                    .padding()
                }
                .padding(.bottom, 1)
                
            }
            .frame(width: 200, height: 200)
            .shadow(radius: 2.5)
        }
        .simultaneousGesture(TapGesture().onEnded { _ in
            // retrieve the courses in this collection
            for courseId in collection.courseIdList! {
                homeController.retrieveCourse(courseId: courseId)
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    CollectionCard()
//}
