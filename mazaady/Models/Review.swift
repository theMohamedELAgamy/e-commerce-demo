import Foundation

struct Review: Codable {
    let id: Int
    let userProfileImage: String?
    let userName: String
    let rating: Double
    let comment: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userProfileImage = "user_profile_image"
        case userName = "user_name"
        case rating
        case comment
        case date
    }
}



// MARK: - Mock Data
extension Review {
    static var mockReviews: [Review] {
        return [
            Review(
                id: 1,
                userProfileImage: nil,
                userName: "Ahmed Mohamed",
                rating: 5.0,
                comment: "Great seller, item was exactly as described. Fast shipping too!",
                date: "2025-03-15"
            ),
            Review(
                id: 2,
                userProfileImage: nil,
                userName: "Nour Ali",
                rating: 4.5,
                comment: "Very good quality, would buy from again.",
                date: "2025-03-10"
            ),
            Review(
                id: 3,
                userProfileImage: nil,
                userName: "Omar Khaled",
                rating: 5.0,
                comment: "Excellent communication and service.",
                date: "2025-03-05"
            ),
            Review(
                id: 4,
                userProfileImage: nil,
                userName: "Layla Hassan",
                rating: 4.0,
                comment: "Item was as described, slight delay in shipping.",
                date: "2025-02-28"
            ),
            Review(
                id: 5,
                userProfileImage: nil,
                userName: "Youssef Ibrahim",
                rating: 5.0,
                comment: "Perfect transaction, highly recommend this seller!",
                date: "2025-02-20"
            )
        ]
    }
}
