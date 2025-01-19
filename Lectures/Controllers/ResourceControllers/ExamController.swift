//
//  ExamController.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import FirebaseFirestore
import Foundation

class ExamController : ObservableObject {
    
    // ExamId : Exam
    @Published var cachedExams: [String : Resource] = [:]
    
    // TODO: Should we also store a map of courseIds : Resource?
    
    // Firestore
    let db = Firestore.firestore()
    
    func retrieveExam(examId: String) {
        // if it's already cached don't do another lookup
        if let _ = cachedExams[examId] {
//            print("exam already cached")
            return
        }
        
        // Use Main actor because cachedExams which is the updated published property determinies behavior in the UI, so it's logic should be on the main thread.
        Task { @MainActor in
            let docRef = db.collection("exams").document(examId)
            
            do {
                let exam = try await docRef.getDocument(as: Resource.self)
                
                // add the exam to the cache
                self.cachedExams[examId] = exam
            } catch {
                print("Error decoding exam: \(error)")
            }
        }
    }
}
