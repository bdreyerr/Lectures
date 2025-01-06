import FirebaseFirestore
import Foundation

class HomeworkController : ObservableObject {
    
    // ExamId : Exam
    @Published var cachedHomeworks: [String : Resource] = [:]
    
    // TODO: Should we also store a map of courseIds : Resource?
    
    // Firestore
    let db = Firestore.firestore()
    
    func retrieveHomework(homeworkId: String) {
        // if it's already cached don't do another lookup
        if let _ = cachedHomeworks[homeworkId] {
            print("homework already cached")
            return
        }
        
        // Use Main actor because cachedNotes which is the updated published property determinies behavior in the UI, so it's logic should be on the main thread.
        Task { @MainActor in
            let docRef = db.collection("homeworks").document(homeworkId)
            
            do {
                let homework = try await docRef.getDocument(as: Resource.self)
                
                // add the exam to the cache
                self.cachedHomeworks[homeworkId] = homework
            } catch {
                print("Error decoding homework: \(error)")
            }
        }
    }
}
