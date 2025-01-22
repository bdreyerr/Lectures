//
//  LicenseInformation.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/22/25.
//

import SwiftUI

struct LicenseInformation: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("License Information")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                // Lecture Content Section
                LicenseSectionView(
                    title: "Lecture Content and Video Materials",
                    content: "The lectures and video content available in this application are not owned by Lectura. All video content is sourced from publicly available YouTube channels maintained by their respective universities and educational institutions. The rights to these lectures, including but not limited to:",
                    bulletPoints: [
                        "Video recordings",
                        "Audio content",
                        "Visual presentations",
                        "Lecture slides shown in videos",
                        "Original course materials presented in lectures"
                    ],
                    footer: "remain the exclusive property of their respective universities, professors, and content creators. Our application serves as an educational platform that organizes and presents this publicly available content in an accessible format for learning purposes."
                )
                
                // Supplementary Resources Section
                LicenseSectionView(
                    title: "Supplementary Educational Resources",
                    content: "The supplementary educational resources provided alongside the lectures, including:",
                    bulletPoints: [
                        "Practice problems",
                        "Study guides",
                        "Sample examinations",
                        "Problem sets",
                        "Learning exercises",
                        "Study materials",
                        "Review questions"
                    ],
                    footer: "are original works created by Lectura, inspired by and based on the concepts and topics discussed in the associated lectures. While these resources are designed to complement the lecture content, they are distinct and original materials."
                )
                
                // Usage Rights Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Usage Rights and Restrictions")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Educational Use License")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("The supplementary educational resources are provided under a limited educational use license. This license:")
                        .padding(.bottom, 4)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        PermissionsView(
                            title: "Permits users to:",
                            items: [
                                "Access and use the materials for personal educational purposes",
                                "Make copies for individual study use",
                                "Share with other registered users within the platform's ecosystem"
                            ]
                        )
                        
                        PermissionsView(
                            title: "Strictly prohibits:",
                            items: [
                                "Commercial use or monetization of any kind",
                                "Distribution outside the platform",
                                "Creation of derivative works for commercial purposes",
                                "Using the materials in paid tutoring or educational services",
                                "Republishing or redistributing the content on other platforms"
                            ]
                        )
                    }
                }
                
                // Commercial Use Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Commercial Use Restriction")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("The supplementary educational resources provided in this application are strictly for educational purposes only. Any commercial use, including but not limited to:")
                    
                    BulletListView(items: [
                        "Selling or monetizing the materials",
                        "Using the materials in paid courses",
                        "Incorporating the materials into commercial educational products",
                        "Using the materials in paid tutoring services",
                        "Creating and selling derivative works"
                    ])
                    
                    Text("is expressly prohibited without written permission from Lectura.")
                }
                
                // Copyright Notice
                VStack(alignment: .leading, spacing: 12) {
                    Text("Copyright Notice")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("© \(Calendar.current.component(.year, from: Date())) Lectura. All rights reserved for supplementary educational resources.")
                    
                    Text("The application respects the intellectual property rights of all content creators and universities. If you believe any content violates copyright law or requires additional attribution, please contact our support team immediately.")
                }
                
                // Disclaimer
                VStack(alignment: .leading, spacing: 12) {
                    Text("Disclaimer")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("While we strive to ensure all supplementary materials are original and do not infringe on any existing copyrights, we respect the intellectual property rights of others. If you believe any content violates your copyright, please contact us with relevant details for prompt review and appropriate action.")
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    
}

// Helper Views
struct LicenseSectionView: View {
    let title: String
    let content: String
    let bulletPoints: [String]
    let footer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(content)
            
            BulletListView(items: bulletPoints)
            
            Text(footer)
        }
        .padding(.bottom, 10)
    }
}

struct PermissionsView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.semibold)
            
            BulletListView(items: items)
        }
        .padding(.bottom, 10)
    }
}

struct BulletListView: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                    Text(item)
                }
            }
        }
        .padding(.leading, 4)
        .padding(.bottom, 10)
    }
}

#Preview {
    LicenseInformation()
}
