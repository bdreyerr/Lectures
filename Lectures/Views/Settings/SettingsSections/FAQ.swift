//
//  FAQ.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/22/25.
//

import SwiftUI

struct FAQ: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Text("Frequently Asked Questions")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                FAQItem(
                    question: "What content is available on this app?",
                    answer: "Our app provides access to publicly available university lectures from various institutions worldwide. These lectures are sourced from YouTube and cover a wide range of subjects including Computer Science, Mathematics, Physics, and more."
                )
                
                FAQItem(
                    question: "Is the content really free?",
                    answer: "Yes! All lectures and educational resources on our platform are completely free. The content comes from publicly available sources, and we've organized it to make learning more accessible."
                )
                
                FAQItem(
                    question: "How does Pro Account work?",
                    answer: "If you initially signed up with a Pro account or you chose to upgrade later, you will recieve additional features in the app to personalize your learning journey. You can access additional features such as: Course History, Extensive Search, Following Channels, Saving Lectures, Related Course Recommendations and more."
                )
                
                FAQItem(
                    question: "I bought a Pro account but want to log in to Lectura using another account",
                    answer: "Your subscription status will track across accounts as long as you are logging in on the same device. In order for your subcription to track across multiple devices, you will need to login in to Lectura using the same method which you used for the account where the Pro subscription was purchased."
                )
                
                FAQItem(
                    question: "I bought pro account but the app is telling me I have a free account",
                    answer: "Sometimes the app can lose track of your subscription status, but don't worry if you navigate to Settings > Subscription Type and click Restore Purchases, your subscription status should return."
                )
                
                FAQItem(
                    question: "What additional resources are available?",
                    answer: "Each lecture comes with supplementary learning materials such as lecture notes, practice problems, reading lists, and links to relevant educational resources. These materials are also freely available and carefully curated to enhance your learning experience."
                )
                
                FAQItem(
                    question: "Can I download lectures for offline viewing?",
                    answer: "You cannot download lectures on this app, but you may be able to through youtube itself."
                )
                
                FAQItem(
                    question: "How are the courses organized?",
                    answer: "Courses are organized by subject, university, and difficulty level. You can browse through different categories or use our search feature to find specific topics."
                )
                
                FAQItem(
                    question: "Can I track my progress?",
                    answer: "Yes, the app includes features to track your progress through courses, mark lectures as completed, and save your favorite content for later viewing."
                )
                
                FAQItem(
                    question: "How can I report technical issues or suggest improvements?",
                    answer: "You can report issues or provide feedback through the Settings menu in the app. We value user feedback and continuously work to improve the learning experience."
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    FAQ()
}
