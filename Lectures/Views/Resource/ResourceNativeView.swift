//
//  ResourceNativeView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/30/25.
//

import SwiftUI

struct ResourceNativeView: View {
    @EnvironmentObject var userController: UserController
    
    
    var resourceTitle: String
    var resourceContent: String
    
    @State var showingSignInSheet: Bool = false
    @State var showingUpgradeSheet: Bool = false
    @State private var showingShare = false
    
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
            
            print(outputString)
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
                        if userController.user == nil {
                            self.showingSignInSheet = true
                            return
                        }
                        
                        if let user = userController.user, let accountType = user.accountType {
                            if accountType == 0 {
                                self.showingUpgradeSheet = true
                                return
                            }
                        }
                        
                        showingShare = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 15, height: 20)
                    }
                }
                .padding(.bottom, 20)
                
                Text(attributedText)
                    .textSelection(.enabled)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingSignInSheet) {
            FirstOpenSignUpSheet(text: "", displaySheet: $showingSignInSheet)
                .presentationDetents([.fraction(0.4), .medium]) // User can drag between these heights
        }
        .sheet(isPresented: $showingUpgradeSheet) {
            UpgradeAccountPaywallWithoutFreeTrial()
        }
        .sheet(isPresented: $showingShare) {
            ShareSheetHelper(items: [generatePDF()])
        }
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
