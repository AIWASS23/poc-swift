import Foundation

struct UserData {
    let id: String
    let email: String
    let nickname: String
    let username: String
    let doesCurrentUserFollowsThisUser: Bool
    let bio: String
    let profileImageUrl: String
    
    init(id: String, email: String, nickname: String, username: String, doesCurrentUserFollowsThisUser: Bool, bio: String, profileImageUrl: String) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.username = username
        self.doesCurrentUserFollowsThisUser = doesCurrentUserFollowsThisUser
        self.bio = bio
        self.profileImageUrl = profileImageUrl
    }
}
