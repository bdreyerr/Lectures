import FirebaseFirestore
import Foundation

class NotesController : ObservableObject {
    
    // ExamId : Exam
    @Published var cachedNotes: [String : Resource] = [:]
    
    
    
    // TODO: Should we also store a map of courseIds : Resource?
    
    // Firestore
    let db = Firestore.firestore()
    
    func retrieveNote(noteId: String) {
        // if it's already cached don't do another lookup
        if let _ = cachedNotes[noteId] {
//            print("note already cached")
            return
        }
        
        // Use Main actor because cachedNotes which is the updated published property determinies behavior in the UI, so it's logic should be on the main thread.
        Task { @MainActor in
            let docRef = db.collection("notes").document(noteId)
            
            do {
                let note = try await docRef.getDocument(as: Resource.self)
                
                // add the exam to the cache
                self.cachedNotes[noteId] = note
            } catch {
                print("Error decoding note: \(error)")
            }
        }
    }
}
