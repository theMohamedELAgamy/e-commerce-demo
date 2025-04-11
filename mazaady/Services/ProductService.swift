import Foundation

// Protocol for product service
protocol ProductServiceProtocol {
    func fetchProducts(searchQuery: String?, completion: @escaping (Result<[Product], APIError>) -> Void)
    func fetchProductDetails(productId: Int, completion: @escaping (Result<Product, APIError>) -> Void)
}

// Product service implementation
class ProductService: ProductServiceProtocol {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    // Fetch products
    func fetchProducts(searchQuery: String?, completion: @escaping (Result<[Product], APIError>) -> Void) {
        dataManager.fetchProducts(searchQuery: searchQuery, completion: completion)
    }
    
    // Fetch product details
    func fetchProductDetails(productId: Int, completion: @escaping (Result<Product, APIError>) -> Void) {
        dataManager.fetchProducts(searchQuery: nil) { result in
            switch result {
            case .success(let products):
                // Find product with matching ID
                if let product = products.first(where: { $0.id == productId }) {
                    completion(.success(product))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
