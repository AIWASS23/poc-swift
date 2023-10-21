import Foundation
import FirebaseFirestore

struct DataAndLastDocument {
    let lastDocument: QueryDocumentSnapshot?
    let Data: [Data]
    
    init(lastDocument: QueryDocumentSnapshot?, Data: [Data]) {
        self.lastDocument = lastDocument
        self.Data = Data
    }
}
