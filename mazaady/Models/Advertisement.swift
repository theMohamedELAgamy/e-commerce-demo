import Foundation

struct Advertisement: Codable {
    let id: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "image"
    }
}



// MARK: - Mock Data
extension Advertisement {
    static var mockAdvertisements: [Advertisement] {
        return [
            Advertisement(
                id: 1,
                imageUrl: "summer_sale_banner.jpg"
            ),
            Advertisement(
                id: 2,
                imageUrl: "summer_sale_banner.jpg"
            ),
            Advertisement(
                id: 3,
                imageUrl: "summer_sale_banner.jpg"
            )
        ]
    }
}
