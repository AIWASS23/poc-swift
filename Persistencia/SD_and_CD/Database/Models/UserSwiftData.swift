import Foundation
import SwiftData

@Model
class UserSwiftData {
    var name: String?
    @Relationship(deleteRule: .cascade) var objectives: [ObjectiveSwiftData]?
    
    init(name: String? = nil,
         objectives: [ObjectiveSwiftData]? = nil) {
        self.name = name
        self.objectives = objectives
    }
}
