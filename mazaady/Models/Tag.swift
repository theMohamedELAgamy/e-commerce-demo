import Foundation

struct Tag: Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

// API Response wrapper


// MARK: - Mock Data
extension Tag {
    static var mockTags: [Tag] {
        return [
            Tag(id: 1, name: "Furniture"),
            Tag(id: 2, name: "Antiques"),
            Tag(id: 3, name: "Jewelry"),
            Tag(id: 4, name: "Home Decor"),
            Tag(id: 5, name: "Art"),
            Tag(id: 6, name: "Clothing"),
            Tag(id: 7, name: "Books"),
            Tag(id: 8, name: "Collectibles")
        ]
    }
}
