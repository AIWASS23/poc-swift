import Foundation

class Sprint: Identifiable, Codable {
    var id: Int32
    var name: String
    var goal: String
    var startTime: Date?
    var projectID: Int32
    var active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case goal = "sprintGoal"
        case startTime
        case projectID
        case active
    }
    
    init(name: String, projectID: Int32 = -1, goal: String, startTime: Date? = nil, active: Bool = false) {
        self.id = -1
        self.name = name
        self.goal = goal
        self.projectID = projectID
        self.startTime = startTime
        self.active = active
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int32.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.goal = try container.decode(String.self, forKey: .goal)
        
        //As custom date decoding strategy cannot decode NULL value nor return nil if founds one
        //try container.decodeIfPresent has been changed to below line
        //in case of invalid data (not probable) or NULL value it will set nill to startTime insted of throwin an error
        self.startTime = try? container.decode(Date.self, forKey: .startTime)
        self.projectID = try container.decode(Int32.self, forKey: .projectID)
        self.active = try container.decode(Bool.self, forKey: .active)
    }
}

extension Sprint {
    var hasStartDate: Bool {
        self.startTime == nil ? false : true
    }
}
