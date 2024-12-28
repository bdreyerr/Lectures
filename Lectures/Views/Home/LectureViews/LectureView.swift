//
//  LectureView.swift
//  Lectures
//
//  Created by Ben Dreyer on 12/19/24.
//

import SwiftUI

struct LectureView: View {
    @Environment(\.colorScheme) var colorScheme
    
    
    @State var image: String = "mit"
    @State var duration: Double = 0.6
    
    var lectures = ["Lecture I", "Lecture II", "Lecture III", "Lecture IV"]
    @State var selectedLecture = ""
    
    @State var isLectureLiked: Bool = false
    
    @State private var dashPhase1: CGFloat = 0
    @State private var dashPhase2: CGFloat = 100
    @State private var hue1: Double = 0.0
    @State private var hue2: Double = 08
    
    init() {
        selectedLecture = lectures[0]
    }
    
    var body: some View {
        VStack {
            // Playback view (starts paused)
            ZStack(alignment: .bottomLeading) {
                Image(image)
                    .resizable()
                    .border(Color.green)
                    .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
                    .aspectRatio(contentMode: .fit)
                
                
                // Add semi-transparent gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.85)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Make gradient fill entire space
                
                
                HStack {
                    Spacer()
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "play.fill")
                                .foregroundColor(Color(hue: 0.001, saturation: 0.95, brightness: 0.973))
                        )
                        .padding()
                }
                
                // progress bar
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: geometry.size.width * duration, height: 3) // 30% progress
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(height: 3)
                .padding(.horizontal, 0)
            }
            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.6)
            .shadow(radius: 2.5)
            .border(Color.black)
            Spacer()
            
            // Course Indicator & Lecture Picker
            
            
            ScrollView() {
                VStack(alignment: .leading) {
                    HStack {
                        Text("1. Introduction to 'Scociety of Mind'")
                            .font(.system(size: 18, design: .serif))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Save button
                        if !isLectureLiked {
                            Image(systemName: "heart")
                                .font(.system(size: 18, design: .serif))
                                .onTapGesture {
                                    self.isLectureLiked.toggle()
                                }
                        } else {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 18, design: .serif))
                                .foregroundStyle(Color.red)
                                .onTapGesture {
                                    self.isLectureLiked.toggle()
                                }
                        }
                    }
                    
                    // Professor if avaialble
                    Text("Marvin Minsky")
                        .font(.system(size: 14, design: .serif))
                        .opacity(0.8)
                    
                    HStack {
                        Text("1.3M views")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.8)
                        
                        Text("Dec 22nd 2013")
                            .font(.system(size: 12, design: .serif))
                            .opacity(0.8)
                    }
                    .padding(.top, 1)
                    
                    // Course Publisher
                    HStack {
                        // Profile Picture
                        Image("stanford")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: 40, height: 40)
                        
                        
                        VStack {
                            // Handle
                            HStack {
                                Text("MIT")
                                    .font(.system(size: 12, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                
                                Text("15 Courses | 312 Lectures")
                                    .font(.system(size: 12, design: .serif))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .opacity(0.7)
                            }
                        }
                        
                    }
                    
                    // Notes
                    HStack {
                        Text("Notes")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.blue)
                            .font(.system(size: 14, design: .serif))
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.clear)
                        .frame(minWidth: 200)
                        .frame(height: 30)
                        .overlay {
                            HStack {
                                Image(systemName: "doc.circle")
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                
                                Text("The Emotion Machine - Lecture I: Science of the Mind")
                                    .font(.system(size: 12, design: .serif))
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    
                    // Homework Assignment
                    HStack {
                        Text("Homework")
                            .font(.system(size: 14, design: .serif))
                            .bold()
                        Image(systemName: "sparkles")
                            .foregroundStyle(Color.blue)
                            .font(.system(size: 14, design: .serif))
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.clear)
                        .frame(minWidth: 200)
                        .frame(height: 30)
                        .overlay {
                            HStack {
                                Image(systemName: "doc.circle")
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.red, .orange, .yellow, .green, .blue, .purple],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                
                                Text("The Emotion Machine - Lecture I: Science of the Mind")
                                    .font(.system(size: 12, design: .serif))
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    
                    
                    // Next Lessons
                    MoreLecturesInSameCourseModule()
                        .padding(.top, 10)
                }
                .padding(.top, 5)
                .padding(.horizontal, 20)
                
                Divider()
                
                // Logo
                if (colorScheme == .light) {
                    Image("LogoTransparentWhiteBackground")
                        .resizable()
                        .frame(width: 80, height: 80)
                } else if (colorScheme == .dark) {
                    Image("LogoBlackBackground")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                Text("Lectura")
                    .font(.system(size: 15, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .opacity(0.8)
                Text("version 1.1")
                    .font(.system(size: 11, design: .serif))
                    .frame(maxWidth: .infinity, alignment: .bottom)
                    .opacity(0.8)
            }
            
        }
//        .onAppear {
//            withAnimation(
//                Animation.linear(duration: 1.0)
//                    .repeatForever(autoreverses: false)
//            ) {
//                dashPhase1 -= 30
//                dashPhase2 -= 30
//            }
//            withAnimation(
//                Animation.linear(duration: 5.0)
//                    .repeatForever(autoreverses: true)
//            ) {
//                hue1 += 4
//                hue2 += 4
//            }
//        }
        //        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    LectureView()
}
