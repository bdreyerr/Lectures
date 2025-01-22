//
//  PrivacyPolicy.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/22/25.
//

import SwiftUI

struct PrivacyPolicy: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("Privacy Policy")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                Text("Last Updated: January 22, 2025")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("This Privacy Policy describes how Lectura (\"Lectura\", \"we\", \"us\", or \"our\") collects, uses, and shares your personal information when you use our educational mobile application (\"App\").")
                
                SectionHeader(title: "Information We Collect")
                VStack(alignment: .leading, spacing: 8) {
                    Text("We collect the following information from you when you use the App:")
                    BulletPoint(text: "Personal Information: This may include your name, email address, username, and learning preferences.")
                    BulletPoint(text: "Academic Progress Data: This may include your course progress, completed lectures, quiz results, and study history.")
                    BulletPoint(text: "Usage Data: This may include information about how you use the App, such as which lectures you watch, resources you access, and time spent studying.")
                    BulletPoint(text: "Device Information: This may include information about your device, such as your device type, operating system, and IP address.")
                }
                
                SectionHeader(title: "How We Use Your Information")
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "Provide and operate the educational platform and its features;")
                    BulletPoint(text: "Track and save your learning progress;")
                    BulletPoint(text: "Recommend relevant lectures and educational resources;")
                    BulletPoint(text: "Communicate with you about your educational journey and the App;")
                    BulletPoint(text: "Personalize your learning experience within the App;")
                    BulletPoint(text: "Analyze how you use the App to improve our educational services;")
                    BulletPoint(text: "Comply with legal and regulatory obligations.")
                }
                
                SectionHeader(title: "Sharing Your Information")
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "Educational institutions whose content is featured on our platform;")
                    BulletPoint(text: "Service providers who help us operate the App and provide our services;")
                    BulletPoint(text: "Analytics partners who help us improve our educational offerings;")
                    BulletPoint(text: "Law enforcement or other government officials, if required by law;")
                    BulletPoint(text: "Other third parties with your explicit consent.")
                }
                
                SectionHeader(title: "Academic Data Protection")
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "Your learning progress and academic performance are kept private;")
                    BulletPoint(text: "Educational resources you create or save are stored securely;")
                    BulletPoint(text: "We do not share your individual learning data with universities or content providers.")
                }
                
                SectionHeader(title: "Your Choices")
                VStack(alignment: .leading, spacing: 8) {
                    Text("You can access, update, or delete your personal information by contacting us at support@lectura.com. You can also choose to:")
                    BulletPoint(text: "Control which aspects of your learning progress are visible to others;")
                    BulletPoint(text: "Opt out of educational content recommendations;")
                    BulletPoint(text: "Download your learning history and progress data;")
                    BulletPoint(text: "Delete your account and associated learning data.")
                }
                
                SectionHeader(title: "Security")
                Text("We implement appropriate technical and organizational measures to protect your personal and academic information. However, no internet transmission is completely secure, and we cannot guarantee absolute security of your information.")
                
                SectionHeader(title: "Educational Content")
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "The lecture content available through our App is sourced from publicly available university courses;")
                    BulletPoint(text: "We strive to ensure all educational content is appropriate and accurate;")
                    BulletPoint(text: "If you encounter any issues with course content, please report it through our support system.")
                }
                
                SectionHeader(title: "Age Restrictions")
                Text("The App is intended for users aged 16 and older. Users between 13 and 16 may use the App with parental consent. We do not knowingly collect personal information from users under 13 years of age.")
                
                SectionHeader(title: "Changes to This Policy")
                Text("We may update this Privacy Policy to reflect changes in our practices or for legal compliance. We will notify you of any material changes by posting the new Privacy Policy on the App and sending you an email notification.")
                
                SectionHeader(title: "Contact Us")
                VStack(alignment: .leading, spacing: 8) {
                    BulletPoint(text: "Email: lecturalearning@gmail.com")
                }
                
                SectionHeader(title: "Educational Institution Partnerships")
                Text("If you are accessing content from a specific educational institution through our App, additional privacy terms from that institution may apply. Please refer to the specific institution's privacy policy for more information.")
            }
        }
        .padding(.horizontal, 20)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, 16)
    }
}

struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(text)
                .font(.body)
                .lineLimit(nil)
        }
    }
}

#Preview {
    PrivacyPolicy()
}
