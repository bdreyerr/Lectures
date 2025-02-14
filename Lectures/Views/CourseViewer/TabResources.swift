//
//  TabResources.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/6/25.
//

import SwiftUI

struct TabResources: View {
    @EnvironmentObject var notesController: NotesController
    
    var course: Course
    var playingLecture: Lecture?
    
    // TODO: we somewhere need to fetch the notes
    var body: some View {
        VStack {
            // For now we just have notes, so display it if available
            
            if let lecture = playingLecture {
                HStack {
                    Text("Lecture Notes")
                        .font(.system(size: 14))
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color.blue)
                        .font(.system(size: 14, design: .serif))
                    Spacer()
                }
                .padding(.top, 20)
                
                
                
                // Notes
                if let noteId = lecture.notesResourceId {
                    if let note = notesController.cachedNotes[noteId] {
                        ResourceChip(resource: note)
                            .padding(.bottom, 2)
                    } else if notesController.isLoading == false {
                        VStack(spacing: 12) {
                            Image(systemName: "text.page.badge.magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Text("No notes available for this lecture")
                                .font(.system(size: 12, design: .serif))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 12)
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "play.rectangle")
                        .font(.system(size: 30))
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.top, 40)
                    
                    HStack(spacing: 4) {
                        Text("Play a lecture to view resources")
                    }
                    .font(.system(size: 12, design: .serif))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            // Fetch the resource on open
            if let playingLecture = playingLecture {
                if let noteId = playingLecture.notesResourceId {
                    // if we already have the note, do nothing
                    if let note = notesController.cachedNotes[noteId] { return }
                    
                    notesController.retrieveNote(noteId: noteId)
                } else {
                    print("lecture didn't have an notes Id")
                }
            }
        }
    }
}

//#Preview {
//    TabResources()
//}
