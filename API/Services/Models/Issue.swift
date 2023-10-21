import Foundation

class Issue: Identifiable, Codable {
    var id: Int32
    var name: String
    var description: String
    var estimation: Int32
    var reporter: User
    var asignee: User?
    var priority: IssuePriority
    var status: IssueStatus
    var type: IssueType
    var projectID: Int32
    var sprintID: Int32?
    var comments: Array<Comment>
    
    enum CodingKeys: String, CodingKey {
        case id = "issueID"
        case name
        case description
        case estimation
        case reporter
        case asignee
        case type = "issueTypeID"
        case priority = "issuePriorityID"
        case status = "issueStatusID"
        case projectID
        case sprintID
        case comments
    }
}

extension Issue {
    func toGeneralDTO() -> IssueGeneralDTO {
        IssueGeneralDTO(id: self.id, name: self.name, asignee: self.asignee, status: self.status, type: self.type, priority: self.priority, projectID: self.projectID, sprintID: self.sprintID)
    }
    
    func toDTO() -> IssueDTO {
        IssueDTO(id: self.id, name: self.name, description: self.description, estimation: self.estimation, projectID: self.projectID, type: self.type, priority: self.priority)
    }
}

extension Array where Element == IssueGeneralDTO {
    func with(status: IssueStatus) -> Array<IssueGeneralDTO> {
        self.filter { issue in
            issue.status == status
        }
    }
}

class IssueDTO: Identifiable, Codable {
    let id: Int32
    var name: String
    var description: String
    var estimation: Int32
    var projectID: Int32
    var type: IssueType
    var priority: IssuePriority
    
    enum CodingKeys: String, CodingKey {
        case id = "issueID"
        case name
        case description
        case estimation
        case projectID
        case type = "issueTypeID"
        case priority = "issuePriorityID"
    }
    
    init(id: Int32, name: String, description: String, estimation: Int32, projectID: Int32, type: IssueType, priority: IssuePriority) {
        self.id = id
        self.name = name
        self.description = description
        self.estimation = estimation
        self.projectID = projectID
        self.type = type
        self.priority = priority
    }
    
    convenience init(project: ProjectDTO) {
        self.init(id: -1, name: "", description: "", estimation: 0, projectID: project.id, type: .toDo, priority: .medium)
    }
}

class IssueGeneralDTO: Identifiable, Codable {
    var id: Int32
    let name: String
    let asignee: User?
    let status: IssueStatus
    let type: IssueType
    let priority: IssuePriority
    let projectID: Int32
    let sprintID: Int32?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case asignee
        case type = "issueTypeID"
        case priority = "issuePriorityID"
        case status = "issueStatusID"
        case projectID
        case sprintID
    }
    
    required init(id: Int32, name: String, asignee: User?, status: IssueStatus, type: IssueType, priority: IssuePriority, projectID: Int32, sprintID: Int32?) {
        self.id = id
        self.name = name
        self.asignee = asignee
        self.status = status
        self.type = type
        self.priority = priority
        self.projectID = projectID
        self.sprintID = sprintID
    }
}
