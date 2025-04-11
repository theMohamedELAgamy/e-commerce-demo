import Foundation

// Protocol for user service
protocol UserServiceProtocol {
    func fetchUserProfile(completion: @escaping (Result<User, APIError>) -> Void)
    func fetchFollowers(completion: @escaping (Result<[User], APIError>) -> Void)
}

// User service implementation
class UserService: UserServiceProtocol {
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    // Fetch user profile
    func fetchUserProfile(completion: @escaping (Result<User, APIError>) -> Void) {
        dataManager.fetchUserProfile(completion: completion)
    }
    
    // Fetch followers (mock implementation for now)
    func fetchFollowers(completion: @escaping (Result<[User], APIError>) -> Void) {
        // Mock data for followers since we don't have an endpoint for this yet
        #if DEBUG
        let mockFollowers = [
            User(id: 2, name: "Follower 1", profileImage: nil, username: "@follower1", location: "Cairo, Egypt", followersCount: 10, followingCount: 15),
            User(id: 3, name: "Follower 2", profileImage: nil, username: "@follower2", location: "Alexandria, Egypt", followersCount: 5, followingCount: 8),
            User(id: 4, name: "Follower 3", profileImage: nil, username: "@follower3", location: "Giza, Egypt", followersCount: 20, followingCount: 25)
        ]
        
        completion(.success(mockFollowers))
        #else
        completion(.failure(.serverError))
        #endif
    }
}
