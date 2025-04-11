import Foundation

protocol ProfileViewModelProtocol {
    var user: Observable<User?> { get }
    var products: Observable<[Product]> { get }
    var tags: Observable<[Tag]> { get }
    var advertisements: Observable<[Advertisement]> { get }
    var selectedTabIndex: Observable<Int> { get }
    var isLoading: Observable<Bool> { get }
    var errorMessage: Observable<String?> { get }
    
    func fetchUserProfile()
    func fetchProducts()
    func fetchTags()
    func fetchReviews()
    func fetchAdvertisements()
    func setSelectedTab(index: Int)
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Observables
    var user: Observable<User?> = Observable(nil)
    var products: Observable<[Product]> = Observable([])
    var tags: Observable<[Tag]> = Observable([])
    var advertisements: Observable<[Advertisement]> = Observable([])
    var selectedTabIndex: Observable<Int> = Observable(0)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    // MARK: - Services
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
    
    // MARK: - Public Methods
    func fetchUserProfile() {
        isLoading.value = true
        
        networkManager.fetch(endpoint: .user, responseType: User.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let response):
                    self.user.value = response
                case .failure(let error):
                    self.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func fetchProducts() {
        isLoading.value = true
        
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
    
    func fetchTags() {
        isLoading.value = true
        
        networkManager.fetch(endpoint: .tags, responseType: TagsResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let response):
                    self.tags.value = response.data
                case .failure(let error):
                    self.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func fetchReviews() {
        // Would fetch reviews from API, simplified for this demo
        isLoading.value = true
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading.value = false
        }
    }
    
    func fetchAdvertisements() {
        isLoading.value = true
        
        networkManager.fetch(endpoint: .advertisements, responseType: AdvertisementsResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let response):
                    self.advertisements.value = response.advertisements
                case .failure(let error):
                    self.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    func setSelectedTab(index: Int) {
        selectedTabIndex.value = index
    }
}




