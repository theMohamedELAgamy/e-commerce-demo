import Foundation

struct Product: Codable {
    let id: Int
    let name: String
    let image: String
    let price: Double
    let currency: String
    let offer: Double?
    let endDate: Double?
    
    // Additional properties for UI that aren't in the API response
    var description: String?
    var category: String?
    var sellerName: String?
    var rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case price
        case currency
        case offer
        case endDate = "end_date"
    }
}

// MARK: - Mock Data
extension Product {
    static var mockProducts: [Product] {
        return [
            Product(
                id: 2657,
                name: "m7ma0",
                image: "https://mazaady-test.s3.us-east-2.amazonaws.com/5136/conversions/VojClbjVtodX5wnaYKXKEqfU8LThmuSvL5dKV9qp-medium.jpg",
                price: 1000,
                currency: "USD",
                offer: 34,
                endDate: 259200.000012,
                description: "Beautiful product for sale",
                category: "Home Decor",
                sellerName: "Sarah Ahmed",
                rating: 4.7
            ),
            Product(
                id: 2620,
                name: "m7ma4",
                image: "https://mazaady-test.s3.us-east-2.amazonaws.com/5069/conversions/CsQaIYdC6HYecd9981peNYPAbXHV42Wdgv8M0VCP-medium.jpg",
                price: 105,
                currency: "USD",
                offer: nil,
                endDate: nil,
                description: "Great product for your home",
                category: "Furniture",
                sellerName: "Sarah Ahmed",
                rating: 4.8
            ),
            Product(
                id: 2600,
                name: "for testtt mk",
                image: "https://mazaady-test.s3.us-east-2.amazonaws.com/4988/conversions/1TO51qJAuiNqYdYb5LF40eQGSsAppiLZeJWye01w-medium.jpg",
                price: 106,
                currency: "USD",
                offer: nil,
                endDate: nil,
                description: "Test product with great features",
                category: "Electronics",
                sellerName: "Sarah Ahmed",
                rating: 4.5
            )
        ]
    }
}
