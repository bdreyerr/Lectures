//
//  TabMainView.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/15/25.
//

import SwiftUI

struct TabMainView: View {
    @EnvironmentObject var courseController: CourseController
    @EnvironmentObject var homeController: HomeController
    
    
    var tabName: String
    var body: some View {
        VStack {
            if homeController.isCoursesForYouLoading || homeController.isLeadingChannelsLoading || homeController.isFamousCoursesLoading {
                HomeLoadingView()
            } else {
                
                CoursesForYouList(tabName: tabName)
                    .padding(.top, 10)
                
                ChannelList(tabName: tabName)
                    .padding(.top, 10)
                
                FamousCoursesList(tabName: tabName)
                    .padding(.top, 10)
            }
        }
        .onAppear {
            homeController.retrieveCoursesForYouByTab(tabName: tabName, courseController: courseController)
            homeController.retrieveLeadingChannelsPerTab(tabName: tabName, courseController: courseController)
            homeController.retrieveFamousCoursePerTab(tabName: tabName, courseController: courseController)
        }
    }
}

//#Preview {
//    TabMainView()
//}
