import Foundation

// Enum for API endpoints
enum APIEndpoint {
    case user
    case products
    case tags
    case advertisements
    
    // Factory methods for backward compatibility
    static func getUserInfo() -> APIEndpoint {
        return .user
    }
    
    static func getProducts() -> APIEndpoint {
        return .products
    }
    
    static func getTags() -> APIEndpoint {
        return .tags
    }
    
    static func getAdvertisements() -> APIEndpoint {
        return .advertisements
    }
    
    // Get URL for endpoint
    var url: URL? {
        let baseURLString = Constants.API.baseURL
        
        switch self {
        case .user:
            return URL(string: baseURLString + Constants.API.profileEndpoint)
            
        case .products:
            return URL(string: baseURLString + Constants.API.productsEndpoint)
            
        case .tags:
            return URL(string: baseURLString + Constants.API.tagsEndpoint)
            
            
        case .advertisements:
            return URL(string: baseURLString + Constants.API.adsEndpoint)
        }
    }
    
    // HTTP method
    var httpMethod: String {
        // All endpoints use GET method in this demo
        return "GET"
    }
    
    // Headers
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
            // Add authentication headers if needed (e.g., "Authorization": "Bearer \(token)")
        ]
    }
}
