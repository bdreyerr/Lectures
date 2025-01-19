//
//  ResourceView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import FirebaseStorage
import SwiftUI

struct ResourceView: View {
    @EnvironmentObject var tabbarController: TabBarController
    
    @EnvironmentObject var resourceController: ResourceController
    
    var resource: Resource
    
    @State private var pdfUrl: URL?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading PDF...")
            } else if let pdfUrl = pdfUrl {
                PDFViewerSwiftUI(url: pdfUrl)
                    .onAppear {
                        tabbarController.isTabbarShowing = false
                    }
                    .onDisappear {
                        tabbarController.isTabbarShowing = true
                    }
            } else if let error = errorMessage {
                Text(error)
            }
        }
        .onAppear {
            fetchPDFFromFirebase()
        }
    }
    
    private func fetchPDFFromFirebase() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Construct the path to the PDF in the 'resources' folder
        var childFolder = ""
        var lectureOrCourseId = ""
        switch resource.resourceType {
        case 0:
            childFolder = "notes"
            lectureOrCourseId = resource.lectureId!
        case 1:
            childFolder = "homeworks"
            lectureOrCourseId = resource.lectureId!
        case 2:
            childFolder = "homeworkAnswers"
            lectureOrCourseId = resource.lectureId!
        case 3:
            childFolder = "exams"
            lectureOrCourseId = resource.courseId!
        case 4:
            childFolder = "examAnswers"
            lectureOrCourseId = resource.courseId!
        default:
            childFolder = "notes"
            lectureOrCourseId = resource.lectureId!
        }
        
        let path = "resources/\(childFolder)/\(lectureOrCourseId).pdf"
        
        if let url = resourceController.cachedUrls[path] {
            self.pdfUrl = url
            self.isLoading = false
            return
        }
        
        let pdfRef = storageRef.child(path)
        print(pdfRef.fullPath)
        
        // Download URL generation
        pdfRef.downloadURL { result in
            switch result {
            case .success(let url):
                self.pdfUrl = url
                self.isLoading = false
                resourceController.cachedUrls[path] = url
            case .failure(let error):
                self.errorMessage = "Could not load PDF: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ResourceView(resource: Resource())
        .environmentObject(TabBarController())
}
