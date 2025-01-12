//
//  ResourceView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI

struct ResourceView: View {
    @EnvironmentObject var tabbarController: TabBarController
    
    var resource: Resource

    var body: some View {
        if let pdfUrl = Bundle.main.url(forResource: "test-pdf-doc", withExtension: "pdf") {
            PDFViewerSwiftUI(url: pdfUrl)
                .onAppear {
                    tabbarController.isTabbarShowing = false
                }
                .onDisappear {
                    tabbarController.isTabbarShowing = true
                }
        } else {
            Text("PDF not found")
        }
    }
}

#Preview {
    ResourceView(resource: Resource())
        .environmentObject(TabBarController())
}
