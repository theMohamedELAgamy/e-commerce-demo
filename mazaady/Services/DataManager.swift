import Foundation

// Define CacheServiceProtocol if it's not found


// Protocol for the data manager
protocol DataManagerProtocol {
    func fetchUserProfile(completion: @escaping (Result<User, APIError>) -> Void)
    func fetchProducts(searchQuery: String?, completion: @escaping (Result<[Product], APIError>) -> Void)
    func fetchTags(completion: @escaping (Result<[Tag], APIError>) -> Void)
    func fetchAdvertisements(completion: @escaping (Result<[Advertisement], APIError>) -> Void)
}

// Data manager combines network and cache services
class DataManager: DataManagerProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         cacheService: CacheServiceProtocol = CacheService()) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    // Fetch user profile with caching
    func fetchUserProfile(completion: @escaping (Result<User, APIError>) -> Void) {
        // Check if we have cached data
        if let cachedUser: User = cacheService.getCachedResponse(forKey: Constants.CacheKeys.userProfile) {
            completion(.success(cachedUser))
            return
        }
        
        // Make network request
        networkService.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let response):
                // Cache the response
                self?.cacheService.cacheResponse(response, forKey: Constants.CacheKeys.userProfile)
                completion(.success(response))
            case .failure(let error):
                // For demo purposes, return mock data if network request fails
                #if DEBUG
                completion(.success(User.mockUser))
                #else
                completion(.failure(error))
                #endif
            }
        }
    }
    
    // Fetch products with caching
    func fetchProducts(searchQuery: String?, completion: @escaping (Result<[Product], APIError>) -> Void) {
        // If search query is provided, skip cache and always make a network request
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            networkService.fetchProducts() { result in
                switch result {
                case .success(let products):
                    // Products are already an array, no need to unwrap from response.data
                    completion(.success(products))
                case .failure(let error):
                    // For demo purposes, filter mock data if network request fails
                    #if DEBUG
                    let filteredProducts = Product.mockProducts.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
                    completion(.success(filteredProducts))
                    #else
                    completion(.failure(error))
                    #endif
                }
            }
            return
        }
        
        // Check if we have cached data
        if let cachedProducts: ProductsResponse = cacheService.getCachedResponse(forKey: Constants.CacheKeys.products) {
            completion(.success(cachedProducts))
            return
        }
        
        // Make network request
        networkService.fetchProducts() { [weak self] result in
            switch result {
            case .success(let response):
                // Cache the response
                self?.cacheService.cacheResponse(response, forKey: Constants.CacheKeys.products)
                completion(.success(response))
            case .failure(let error):
                // For demo purposes, return mock data if network request fails
                #if DEBUG
                completion(.success(Product.mockProducts))
                #else
                completion(.failure(error))
                #endif
            }
        }
    }
    
    // Fetch tags with caching
    func fetchTags(completion: @escaping (Result<[Tag], APIError>) -> Void) {
        // Check if we have cached data
        if let cachedTags: TagsResponse = cacheService.getCachedResponse(forKey: Constants.CacheKeys.tags) {
            completion(.success(cachedTags.data))
            return
        }
        
        // Make network request
        networkService.fetchTags { [weak self] result in
            switch result {
            case .success(let response):
                // Cache the response
                self?.cacheService.cacheResponse(response, forKey: Constants.CacheKeys.tags)
                completion(.success(response.data))
            case .failure(let error):
                // For demo purposes, return mock data if network request fails
                #if DEBUG
                completion(.success(Tag.mockTags))
                #else
                completion(.failure(error))
                #endif
            }
        }
    }
    
    // Fetch advertisements with caching
    func fetchAdvertisements(completion: @escaping (Result<[Advertisement], APIError>) -> Void) {
        // Check if we have cached data
        if let cachedAds: AdvertisementsResponse = cacheService.getCachedResponse(forKey: Constants.CacheKeys.advertisements) {
            completion(.success(cachedAds.advertisements))
            return
        }
        
        // Make network request
        networkService.fetchAdvertisements { [weak self] result in
            switch result {
            case .success(let response):
                // Cache the response
                self?.cacheService.cacheResponse(response, forKey: Constants.CacheKeys.advertisements)
                completion(.success(response.advertisements))
            case .failure(let error):
                // For demo purposes, return mock data if network request fails
                #if DEBUG
                completion(.success(Advertisement.mockAdvertisements))
                #else
                completion(.failure(error))
                #endif
            }
        }
    }
    

}

// If using protocol from another file, this won't conflict
#if canImport(CacheServiceProtocol)
// Use existing protocol
#else
// Protocol for cache service
protocol CacheServiceProtocol {
    func cacheResponse<T: Encodable>(_ response: T, forKey key: String)
    func getCachedResponse<T: Decodable>(forKey key: String) -> T?
    func clearCache(forKey key: String)
    func clearAllCache()
}
#endif

// Cache service implementation using UserDefaults (simple implementation for demo)
class CacheService: CacheServiceProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    // Cache a response
    func cacheResponse<T: Encodable>(_ response: T, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(response)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Error caching response: \(error)")
        }
    }
    
    // Get cached response
    func getCachedResponse<T: Decodable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            print("Error retrieving cached response: \(error)")
            return nil
        }
    }
    
    // Clear specific cache
    func clearCache(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    // Clear all cache
    func clearAllCache() {
        let allKeys = [
            Constants.CacheKeys.userProfile,
            Constants.CacheKeys.products,
            Constants.CacheKeys.tags,
            Constants.CacheKeys.advertisements,
        ]
        
        for key in allKeys {
            userDefaults.removeObject(forKey: key)
        }
    }
}
