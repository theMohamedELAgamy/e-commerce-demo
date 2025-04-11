import Foundation

// Protocol for advertisement service
protocol AdvertisementServiceProtocol {
    func fetchAdvertisements(completion: @escaping (Result<[Advertisement], APIError>) -> Void)
}

// Advertisement service implementation
class AdvertisementService: AdvertisementServiceProtocol {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    // Fetch advertisements
    func fetchAdvertisements(completion: @escaping (Result<[Advertisement], APIError>) -> Void) {
        dataManager.fetchAdvertisements(completion: completion)
    }
}
