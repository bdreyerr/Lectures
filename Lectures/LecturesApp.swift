//
//  LecturesApp.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/15/24.
//

import SwiftUI

@main
struct LecturesApp: App {
    // App Storage: isDarkMode variable tracks dark theme throughout the app
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
