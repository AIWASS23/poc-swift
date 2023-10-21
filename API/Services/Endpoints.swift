import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queries: [String: String]? { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    
    var schema: String { get }
    var host: String { get }
    var port: Int { get }

    var version: String { get }
}

enum Endpoints {
    private static var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .customISO8601
        
        return encoder
    }()

    internal enum AuthEndpoint: Endpoint {
        case signIn(request: SignInRequest)
        case signUp(request: SignUpRequest)
        case info
        case refresh(token: String)
        
        var schema: String { "http" }
        var host: String { "127.0.0.1" }
        var port: Int { 8081 }
        var version: String { "/api" }
        
        var headers: [String: String] {
            [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
        }
        
        var path: String {
            switch self {
            case .info:
                return "auth/user-info"
            case .signIn:
                return "auth/sign-in"
            case .signUp:
                return "auth/register"
            case .refresh:
                return "auth/refresh"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .refresh, .signIn, .signUp:
                return .post
            case .info:
                return .get
            }
        }
        
        var queries: [String : String]? {
            switch self {
            case .refresh(let token):
                return ["refreshToken":"\(token)"]
            default:
                return nil
            }
            
        }
        
        var body: Data? {
            switch self {
            case .signIn(let request):
                return try? encoder.encode(request)
            case .signUp(let request):
                return try? encoder.encode(request)
            case .refresh, .info:
                return nil
            }
        }
    }
    
    internal enum IssueEndpoint: Endpoint {
        case create(issue: IssueDTO)
        case update(issue: IssueDTO)
        case delete(issue: IssueGeneralDTO)
        case fetch(project: any ProjectEntity)
        case details(issue: IssueGeneralDTO)
        case backlog(project: any ProjectEntity)
        case history(project: any ProjectEntity)
        case assignTo(issue: IssueDTO)
        case unassignFrom(issue: IssueDTO)
        case assignedTo(sprint: Sprint)
        case change(status: IssueStatus, of: IssueDTO)
        case userAssigned
        
        var schema: String { "http" }
        var host: String { "127.0.0.1" }
        var port: Int { 8081 }
        var version: String { "/api" }
        
        var headers: [String: String] {
            [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
        }
        
        var path: String {
            switch self {
            case .create, .update, .fetch :
                return "issue"
            case .backlog:
                return "issue/product-backlog"
            case .details(let issue):
                return "issue/details/\(issue.id)"
            case .delete(let issue):
                return "issue/\(issue.id)"
            case .assignTo(issue: let issue):
                return "issue/\(issue.id)/assign"
            case .unassignFrom(issue: let issue):
                return "issue/\(issue.id)/delete-assignment"
            case .assignedTo(let sprint):
                return "issue/sprint/\(sprint.id)"
            case .change(let status, let issue):
                return "issue/\(issue.id)/status/\(status.rawValue)"
            case .userAssigned:
                return "issue/user-assigned"
            case .history:
                return "issue/product-backlog-history"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .create, .assignTo:
                return .post
            case .update, .unassignFrom:
                return .put
            case .delete:
                return .delete
            case .fetch, .details, .assignedTo, .backlog, .userAssigned, .history:
                return .get
            case .change:
                return .patch
            }
        }
        
        var queries: [String : String]? {
            switch self {
            case .fetch(let project), .backlog(let project), .history(let project):
                return ["projectID":"\(project.id)"]
            default:
                return nil
            }
        }
        
        var body: Data? {
            switch self {
            case .create(let issue), .update(let issue), .assignTo(let issue), .unassignFrom(let issue):
                return try? encoder.encode(issue)
            default:
                return nil
            }
        }
    }
    
    internal enum SprintEndpoint: Endpoint {
        case create(sprint: Sprint)
        case delete(sprint: Sprint)
        case update(sprint: Sprint)
        case assign(issue: IssueGeneralDTO, to: Sprint)
        case unassign(issue: IssueGeneralDTO, from: Sprint)
        case start(sprint: Sprint)
        case stop(project: any ProjectEntity)
        case ongoing(project: any ProjectEntity)
        case unbegun(project: any ProjectEntity)
        
        var schema: String { "http" }
        var host: String { "127.0.0.1" }
        var port: Int { 8081 }
        var version: String { "/api" }
        
        var headers: [String: String] {
            [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
        }
        
        var path: String {
            switch self {
            case .create, .update:
                return "sprint"
            case .delete(let sprint):
                return "sprint/\(sprint.id)"
            case .assign(let issue, let sprint):
                return "sprint/\(sprint.id)/issue/\(issue.id)"
            case .unassign(let issue, let sprint):
                return "sprint/\(sprint.id)/issue/delete/\(issue.id)"
            case .start(let sprint):
                return "sprint/start/\(sprint.id)"
            case .stop(let project):
                return "sprint/project/\(project.id)/stop"
            case .ongoing(let project):
                return "sprint/active/\(project.id)"
            case .unbegun(let project):
                return "sprint/non-activated/\(project.id)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .create, .assign:
                return .post
            case .update:
                return .put
            case .start, .stop:
                return .patch
            case .ongoing, .unbegun:
                return .get
            case .delete, .unassign:
                return .delete
            }
        }
        
        var queries: [String : String]? { return nil }
        
        var body: Data? {
            switch self {
            case .create(let sprint), .update(let sprint):
                return try? encoder.encode(sprint)
            default:
                return nil
            }
        }
        
    }
    
    internal enum ProjectEndpoint: Endpoint {
        case create(project: ProjectDTO)
        case update(project: ProjectDTO)
        case delete(project: ProjectDTO)
        case fetch
        case details(project: ProjectDTO)
        case invite(request: InviteRequest)
        case remove(request: UserRemovalDTO)
        
        var schema: String { "http" }
        var host: String { "127.0.0.1" }
        var port: Int { 8081 }
        var version: String { "/api" }
        
        var headers: [String: String] {
            [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
        }
        
        var path: String {
            switch self {
            case .create, .fetch, .update:
                return "scrum-project"
            case .details(let project), .delete(let project):
                return "scrum-project/\(project.id)"
            case .invite:
                return "scrum-project/user-association"
            case .remove:
                return "/api/scrum-project/delete-user"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .create, .invite:
                return .post
            case .update:
                return .put
            case .delete, .remove:
                return .delete
            case .fetch, .details:
                return .get
            }
        }
        
        var queries: [String : String]? {
            return nil
        }
        
        var body: Data? {
            switch self {
            case .create(let project), .update(let project):
                return try? encoder.encode(project)
            case .invite(let request):
                return try? encoder.encode(request)
            case .remove(let request):
                return try? encoder.encode(request)
            default:
                return nil
            }
        }
    }
    
    internal enum CommentEndpoint: Endpoint {
        case add(comment: Comment)
        case update(comment: Comment)
        case delete(comment: Comment)
        
        var schema: String { "http" }
        var host: String { "127.0.0.1" }
        var port: Int { 8081 }
        var version: String { "/api" }
        
        var headers: [String: String] {
            [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
        }
        
        var path: String {
            switch self {
            case .add, .update:
                return "comment"
            case .delete(let comment):
                return "comment/\(comment.id)"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .add:
                return .post
            case .update:
                return .put
            case .delete:
                return .delete
            }
        }
        
        var queries: [String : String]? { return nil }
        
        var body: Data? {
            switch self {
            case .add(let comment), .update(let comment):
                return try? encoder.encode(comment)
            default:
                return nil
            }
        }
        
        
    }
}
