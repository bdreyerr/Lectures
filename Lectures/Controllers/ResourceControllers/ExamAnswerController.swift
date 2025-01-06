//
//  ExamAnswerController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import FirebaseFirestore
import Foundation

class ExamAnswerController : ObservableObject {
    
    // ExamId : Exam
    @Published var cachedExamAnswers: [String : Resource] = [:]
    
    // TODO: Should we also store a map of courseIds : Resource?
    
    // Firestore
    let db = Firestore.firestore()
    
    func retrieveExamAnswer(examAnswerId: String) {
        // if it's already cached don't do another lookup
        if let _ = cachedExamAnswers[examAnswerId] {
            print("examAnswer already cached")
            return
        }
        
        // Use Main actor because cachedExams which is the updated published property determinies behavior in the UI, so it's logic should be on the main thread.
        Task { @MainActor in
            let docRef = db.collection("examAnswers").document(examAnswerId)
            
            do {
                let examAnswer = try await docRef.getDocument(as: Resource.self)
                
                // add the exam to the cache
                self.cachedExamAnswers[examAnswerId] = examAnswer
            } catch {
                print("Error decoding exam answer: \(error)")
            }
        }
    }
}
