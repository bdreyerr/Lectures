//
//  ContinueLearningCourseList.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/17/24.
//

import SwiftUI

struct ContinueLearningCourseList: View {
    let images = ["mit", "mit2", "stanford", "mit"] // Replace with your image names
    var body: some View {
        Text("Continue Learning")
            .font(.system(size: 20, design: .serif))
            .frame(maxWidth: .infinity, alignment: .leading)
            .bold()
        
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
//                    ForEach(images, id: \.self) { imageName in
//                        NavigationLink(destination: LectureView()) {
//                            PreviouslyWatchedCourseCard(image: imageName, duration: Double.random(in: 0.1...0.9))
//                        }
//                    }
                    NavigationLink(destination: LectureView()) {
                        PreviouslyWatchedCourseCard(image: images[0], duration: Double.random(in: 0.1...0.9))
                    }
                    NavigationLink(destination: LectureView()) {
                        PreviouslyWatchedCourseCard(image: images[1], duration: Double.random(in: 0.1...0.9))
                    }
                    NavigationLink(destination: LectureView()) {
                        PreviouslyWatchedCourseCard(image: images[2], duration: Double.random(in: 0.1...0.9))
                    }
                    NavigationLink(destination: LectureView()) {
                        PreviouslyWatchedCourseCard(image: images[3], duration: Double.random(in: 0.1...0.9))
                    }
                }
            }
    }
}

#Preview {
    ContinueLearningCourseList()
}
