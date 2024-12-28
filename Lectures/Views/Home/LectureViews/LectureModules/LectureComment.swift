//
//  LectureComment.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI

struct LectureComment: View {
    @State var isLiked: Bool = false
    var body: some View {
        VStack {
            HStack {
                // Profile Picture
                Image("stanford")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 40, height: 40)
                
                
                VStack {
                    // Handle
                    Text("Geroge Blooth")
                        .font(.system(size: 12, design: .serif))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
            
            // Response
            Text("This is the content of the comment and it's pretty good")
                .font(.system(size: 13, design: .serif))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                ZStack {
                    if (!isLiked) {
                        HStack {
                            // like image
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .frame(width: 15, height: 15)
                            // like number
                            Text("1")
                                .font(.system(size: 13, design: .serif))
                        }
                        .onTapGesture {
                            self.isLiked.toggle()
                        }
                    } else {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("2")
                                .font(.system(size: 13, design: .serif))
                        }
                        .foregroundStyle(Color.orange)
                        .onTapGesture {
                            self.isLiked.toggle()
                        }
                    }
                }
                
                HStack {
                    // Comment image
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 15, height: 15)
                    // comment number
                    Text("15")
                        .font(.system(size: 13, design: .serif))
                }
                
                // Report Short
                Image(systemName: "info.circle")
                    .font(.caption)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    LectureComment()
}
