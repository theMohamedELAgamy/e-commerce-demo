import Foundation

protocol ProductListViewModelProtocol {
    var products: Observable<[Product]> { get }
    var isLoading: Observable<Bool> { get }
    var errorMessage: Observable<String?> { get }
    var searchQuery: Observable<String> { get }
    
    func fetchProducts()
    func searchProducts(_ query: String)
    func getProductAt(index: Int) -> Product?
    func numberOfProducts() -> Int
}

class ProductListViewModel: ProductListViewModelProtocol {
    
    // MARK: - Observables
    var products: Observable<[Product]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    var searchQuery: Observable<String> = Observable("")
    
    // MARK: - Services
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    
    // MARK: - Public Methods
    func fetchProducts() {
        isLoading.value = true
        searchQuery.value = ""
        
        networkManager.fetch(endpoint: .products(searchQuery: nil), responseType: ProductsResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let response):
                    self.products.value = response
                case .failure(let error):
                    self.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func searchProducts(_ query: String) {
        guard !query.isEmpty else {
            fetchProducts()
            return
        }
        
        isLoading.value = true
        searchQuery.value = query
        
        networkManager.fetch(endpoint: .products(searchQuery: query), responseType: ProductsResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let response):
                    self.products.value = response
                case .failure(let error):
                    self.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func getProductAt(index: Int) -> Product? {
        guard index < products.value.count else { return nil }
        return products.value[index]
    }
    
    func numberOfProducts() -> Int {
        return products.value.count
    }
}
