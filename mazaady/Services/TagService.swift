import Foundation

// Protocol for tag service
protocol TagServiceProtocol {
    func fetchTags(completion: @escaping (Result<[Tag], APIError>) -> Void)
}

// Tag service implementation
class TagService: TagServiceProtocol {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    // Fetch tags
    func fetchTags(completion: @escaping (Result<[Tag], APIError>) -> Void) {
        dataManager.fetchTags(completion: completion)
    }
}
