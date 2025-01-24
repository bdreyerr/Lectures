//
//  ReportIssues.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/22/25.
//

import FirebaseFirestore
import SwiftUI

struct ReportIssues: View {
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userController: UserController
    
    @State var issueText: String = ""
    
    // Firestore
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                
                Text("Report Issues")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .padding(.bottom, 10)
                
                VStack {
                    HStack {
                        // Search Icon
                        Image(systemName: "exclamationmark.circle")
                        
//                        // Search TextField
                        TextField("Your Issue", text: $issueText)
                            .font(.system(size: 16))
                            .textFieldStyle(PlainTextFieldStyle())
                            .textFieldStyle(PlainTextFieldStyle())
                            .lineLimit(1...5)  // This allows up to 5 lines before scrolling
                        
                    }
                }
                .padding(10)
                .background(colorScheme == .light ? Color.black.opacity(0.05) : Color.white.opacity(0.2))
                .cornerRadius(20) // Rounded corners
        //        .padding(.horizontal)
                .padding(.top, 10)
                
                
                // submit button
                Button(action: {
                    // TODO: rate limit
                    if self.issueText == "" { return }
                    
                    Task { @MainActor in
                        // Add a new document in collection "cities"
                        do {
                            if let user = userController.user, let id = user.id {
                                let ref = try await db.collection("issues").addDocument(data: [
                                  "reportingUser": id,
                                  "issueText": issueText,
                                  "timestamp": Timestamp()
                                ])
                                
                                self.issueText = ""
                            } else {
                                // user can't report an issue if not logged in
                                print("user not logged in")
                            }
                        } catch {
                            print("error writing issue")
                        }
                    }
                }) {
                    Text("Submit")
                        .font(.system(size: 16, design: .serif))
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 20)
    }
}

//#Preview {
//    ReportIssues()
//}
