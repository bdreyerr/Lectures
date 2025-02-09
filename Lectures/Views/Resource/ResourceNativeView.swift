//
//  ResourceNativeView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/30/25.
//

import SwiftUI

struct ResourceNativeView: View {
    @Environment(\.presentationMode) var presentationMode
//    @AppStorage("isSignedIn") private var isSignedIn = false
    
    @EnvironmentObject var userController: UserController
    
    @EnvironmentObject var subscriptionController: SubscriptionController
    
    @EnvironmentObject var courseController: CourseController
    
    @EnvironmentObject var rateLimiter: RateLimiter
    
    var resourceType: Int
    var resourceTitle: String
    var resourceContent: String
    
    @State var showingSignInSheet: Bool = false
    @State var showingUpgradeSheet: Bool = false
    @State private var showingShare = false
    @State private var showingReportAlert = false
    
    let markdownNotes = """
**My Important Notes**\n
Here are some key points from today's meeting:\n
**Project Updates**\n
The new feature launch is going **really well**! We've seen:
• *Increased* user engagement
• **25%** improvement in load times
• Support for basic styling\n
**Next Steps**\n
• Complete documentation
• Schedule user testing
• Plan marketing campaign\n
Note: Remember to follow up with the design team about the new color scheme.\n
Visit our [internal wiki](https://wiki.example.com) for more details.\n
*Last updated: January 30, 2025*
"""
    
    private var attributedText: AttributedString {
        do {
            // Replace \\n with actual newline characters
            let outputString = resourceContent.replacingOccurrences(of: "\\n", with: "\n")
            
            return try AttributedString(markdown: outputString, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        } catch {
            print("Error converting markdown: \(error)")
            return AttributedString("Failed to load notes")
        }
    }
    
    private func generatePDF() -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // US Letter size
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: UIColor.black
            ]
            
            let contentAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
            
            // Draw title
            resourceTitle.draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
            
            // Convert AttributedString to NSAttributedString for drawing
            let nsAttributedString = try? NSAttributedString(attributedText)
            
            // Create frame for content
            let contentRect = CGRect(x: 50, y: 80, width: 512, height: 662)
            nsAttributedString?.draw(in: contentRect)
        }
        
        return data
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Text(resourceTitle)
                        .font(.system(size: 16, design: .serif))
                        .opacity(0.9)
                    
                    Spacer()
                    
                    // share button
                    Button(action: {
                        // case where no user
                        
                        // only check is pro
                        if !subscriptionController.isPro {
                            self.showingUpgradeSheet = true
                            return
                        }
                        
                        showingShare = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 15, height: 20)
                    }
                    .padding(.trailing, 5)
                    
                    // report button
                    Button(action: {
                        if let rateLimit = rateLimiter.processWrite() {
                            print(rateLimit)
                            return
                        }
                        
                        self.showingReportAlert = true
                    }) {
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    .alert("Report an Issue", isPresented: $showingReportAlert) {
                        Button("Content is Missing") {
                            courseController.reportIssueWithResource(resourceType: resourceType, resourceId: resourceTitle, issue: "Content is Missing")
                        }
                        Button("Content is Unrelated") {
                            courseController.reportIssueWithResource(resourceType: resourceType, resourceId: resourceTitle, issue: "Content is Unrelated")
                        }
                        Button("Formatting Issues") {
                            courseController.reportIssueWithResource(resourceType: resourceType, resourceId: resourceTitle, issue: "Formatting Issues")
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Select the issue with this resource content:")
                    }
                }
                .padding(.bottom, 20)
                
                
                // if there was no generated resource for this (probably meant the transcript wasn't available on the video)
                if resourceContent == "" {
                    VStack(spacing: 12) {
                        Image(systemName: "face.smiling.inverse")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        
                        Text("This resource is not available")
                            .font(.system(size: 16, design: .serif))
                            .foregroundColor(.gray)
                        
                        Text("This usually means the YouTube video does not have a transcript, or we had trouble generating the content on our server")
                            .font(.system(size: 14, design: .serif))
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 40)
                } else {
                    Text(attributedText)
                        // We probably don't want this text selectable, forces the user to use share, which is a pro feature
//                        .textSelection(.enabled)
                    
                    Divider()
                    
                    BottomBrandView()
                        .padding(.bottom, 20)
                        
                    
                    HStack {
                        Text("The following content has been generated by an artificial intelligence (AI) system. While every effort has been made to ensure accuracy, AI-generated content may contain errors or inaccuracies. Users are advised to exercise caution and not rely solely on this content as absolute truth. Always verify critical information from trusted sources.\n")
                            .font(.system(size: 10, design: .serif))
                        Spacer()
                    }
                        
                        
                    HStack {
                        Text("This content was generated based on the linked recorded lecture. It adheres to all licensing and copyright policies associated with the original lecture material. The AI has synthesized and reformatted the information for clarity and accessibility, but the intellectual property rights remain with the original creators of the lecture.")
                            .font(.system(size: 10, design: .serif))
                        Spacer()
                    }
                    .padding(.bottom, 80)
                    
                }
                
                
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingSignInSheet) {
            FirstOpenSignUpSheet(text: "", displaySheet: $showingSignInSheet)
                .presentationDetents([.fraction(0.25), .medium]) // User can drag between these heights
        }
        .sheet(isPresented: $showingUpgradeSheet) {
            UpgradeAccountPaywallWithoutFreeTrial(sheetShowingView: $showingUpgradeSheet)
        }
        .sheet(isPresented: $showingShare) {
            ShareSheetHelper(items: [generatePDF()])
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .bold()
                Text("Back")
            }
        })
    }
}

// Helper View for sharing
struct ShareSheetHelper: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
