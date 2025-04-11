import Foundation

// Protocol for network service
protocol NetworkServiceProtocol {
    func fetchUserInfo(completion: @escaping (Result<User, APIError>) -> Void)
    func fetchProducts(searchQuery: String?, completion: @escaping (Result<ProductsResponse, APIError>) -> Void)
    func fetchTags(completion: @escaping (Result<TagsResponse, APIError>) -> Void)
    func fetchAdvertisements(completion: @escaping (Result<AdvertisementsResponse, APIError>) -> Void)
}

// Network service implementation
class NetworkService: NetworkServiceProtocol {
    
    private let session: URLSession
    private let networkManager: NetworkManager
    
    init(session: URLSession = .shared, networkManager: NetworkManager = .shared) {
        self.session = session
        self.networkManager = networkManager
    }
    
    // Fetch user profile
    func fetchUserInfo(completion: @escaping (Result<User, APIError>) -> Void) {
        let endpoint = APIEndpoint.getUserInfo()
        performRequest(endpoint: endpoint, completion: completion)
    }
    
    // Fetch products
    func fetchProducts(searchQuery: String?, completion: @escaping (Result<ProductsResponse, APIError>) -> Void) {
        let endpoint = APIEndpoint.getProducts(searchQuery: searchQuery)
        performRequest(endpoint: endpoint, completion: completion)
    }
    
    // Fetch tags
    func fetchTags(completion: @escaping (Result<TagsResponse, APIError>) -> Void) {
        let endpoint = APIEndpoint.getTags()
        performRequest(endpoint: endpoint, completion: completion)
    }
    
    // Fetch advertisements
    func fetchAdvertisements(completion: @escaping (Result<AdvertisementsResponse, APIError>) -> Void) {
        let endpoint = APIEndpoint.getAdvertisements()
        performRequest(endpoint: endpoint, completion: completion)
    }
    
    // Generic request method that uses NetworkManager
    private func performRequest<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, APIError>) -> Void) {
        networkManager.fetch(endpoint: endpoint, responseType: T.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .invalidURL:
                        completion(.failure(.invalidURL))
                    case .invalidResponse:
                        completion(.failure(.serverError))
                    case .requestFailed:
                        completion(.failure(.networkError(error)))
                    case .decodingFailed:
                        completion(.failure(.decodingError(error)))
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
}
