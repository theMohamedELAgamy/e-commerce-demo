import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse(Int)
    case noData
    case decodingError(Error)
    case encodingError
    case unauthorized
    case serverError
    case unknownError
    
    // User-friendly error message
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .invalidResponse(let statusCode):
            return "Invalid Response: Status code \(statusCode)"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Error parsing response: \(error.localizedDescription)"
        case .encodingError:
            return "Error encoding request data"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError:
            return "Server error"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
    
    // Error code for logging or analytics
    var code: Int {
        switch self {
        case .invalidURL:
            return 1001
        case .networkError:
            return 1002
        case .invalidResponse(let statusCode):
            return statusCode
        case .noData:
            return 1003
        case .decodingError:
            return 1004
        case .encodingError:
            return 1005
        case .unauthorized:
            return 401
        case .serverError:
            return 500
        case .unknownError:
            return 9999
        }
    }
}
