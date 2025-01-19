//
//  HomeworkAnswersController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/4/25.
//

import Foundation
import FirebaseFirestore
import Foundation

class HomeworkAnswersController : ObservableObject {
    
    // ExamId : Exam
    @Published var cachedHomeworkAnswers: [String : Resource] = [:]
    
    // TODO: Should we also store a map of courseIds : Resource?
    
    // Firestore
    let db = Firestore.firestore()
    
    func retrieveHomeworkAnswer(homeworkAnswerId: String) {
        // if it's already cached don't do another lookup
        if let _ = cachedHomeworkAnswers[homeworkAnswerId] {
//            print("homework already cached")
            return
        }
        
        // Use Main actor because cachedNotes which is the updated published property determinies behavior in the UI, so it's logic should be on the main thread.
        Task { @MainActor in
            let docRef = db.collection("homeworkAnswers").document(homeworkAnswerId)
            
            do {
                let homeworkAnswer = try await docRef.getDocument(as: Resource.self)
                
                // add the exam to the cache
                self.cachedHomeworkAnswers[homeworkAnswerId] = homeworkAnswer
            } catch {
                print("Error decoding homework answer: \(error)")
            }
        }
    }
}
