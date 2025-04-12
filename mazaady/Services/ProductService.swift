import Foundation

// Protocol for product service
protocol ProductServiceProtocol {
    func fetchProducts( completion: @escaping (Result<[Product], APIError>) -> Void)
}

// Product service implementation
class ProductService: ProductServiceProtocol {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    // Fetch products
    func fetchProducts(completion: @escaping (Result<[Product], APIError>) -> Void) {
        dataManager.fetchProducts(completion: completion)
    }
    

}
