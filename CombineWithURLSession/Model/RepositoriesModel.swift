import Foundation

// MARK: - RepositoriesModel
struct RepositoriesModel: Codable {
    var items: [Item]

    enum CodingKeys: String, CodingKey {
        case items
    }
}

// MARK: - Item
struct Item: Codable, Identifiable {
    let id = UUID()
    let name: String
    let owner: Owner
    let htmlURL: String
    let itemDescription: String?
    let languagesURL: String
    let stargazersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int

    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case languagesURL = "languages_url"
        case stargazersCount = "stargazers_count"
        case language
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let avatarURL: String
    let url: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
    }
}
