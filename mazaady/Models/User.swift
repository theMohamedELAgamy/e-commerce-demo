import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let profileImage: String?
    let username: String
    let location: String
    let followersCount: Int
    let followingCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImage = "image"
        case username="user_name"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case location="country_name"

    }
}



// MARK: - Mock Data
extension User {
    static var mockUser: User {
        return User(
            id: 1,
            name: "Sarah Ahmed",
            profileImage: "",
            username: "@sarah_ahmed",
            location: "Cairo, Egypt",
            followersCount: 1243,
            followingCount: 567
        )
    }
}
