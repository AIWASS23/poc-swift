import Foundation

protocol ProjectEntity {
    var id: Int32 { get set }
}

class Project: ProjectEntity, Identifiable, Codable {
    var id: Int32
    var name: String
    var description: String
    var goal: String?
    var members: Array<User>
    var owner: User
    
    enum CodingKeys: String, CodingKey {
        case id = "projectID"
        case name
        case description
        case members
        case owner
        case goal = "projectGoal"
    }
}

extension Project {
    func toDTO() -> ProjectDTO {
        ProjectDTO(id: self.id, name: self.name, description: self.description, goal: self.goal)
    }
}

class ProjectDTO: ProjectEntity, Identifiable, Codable {
    var id: Int32
    var name: String
    var description: String
    var goal: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "projectID"
        case name
        case description
        case goal = "projectGoal"
    }
    
    init(id: Int32 = -1, name: String, description: String, goal: String?) {
        self.id = id
        self.name = name
        self.description = description
        self.goal = goal
    }
}
