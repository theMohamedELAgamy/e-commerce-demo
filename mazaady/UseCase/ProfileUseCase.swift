//
//  ProfileUseCase.swift
//  mazaady
//
//  Created by Mohamed on 12/04/2025.
//

protocol ProfileUseCaseProtocol{
    func fetchAdvertisements(completion: @escaping (Result<[Advertisement], APIError>) -> Void)
    func fetchProducts(completion: @escaping (Result<[Product], APIError>) -> Void)
    func fetchUserProfile(completion: @escaping (Result<User, APIError>) -> Void)
    func fetchFollowers(completion: @escaping (Result<[User], APIError>) -> Void)
    func fetchTags(completion: @escaping (Result<[Tag], APIError>) -> Void)

}


class ProfileUseCase:ProfileUseCaseProtocol{
    
    private var productService:ProductServiceProtocol
    private var UserService:UserServiceProtocol
    private var TagService:TagServiceProtocol
    private var advertisementService:AdvertisementServiceProtocol
    
    init(productService: ProductServiceProtocol, UserService: UserServiceProtocol, TagService: TagServiceProtocol, advertisementService: AdvertisementServiceProtocol) {
        self.productService = productService
        self.UserService = UserService
        self.TagService = TagService
        self.advertisementService = advertisementService
    }
    
    func fetchAdvertisements(completion: @escaping (Result<[Advertisement], APIError>) -> Void) {
        return self.advertisementService.fetchAdvertisements(completion: completion)
    }
    
    func fetchProducts( completion: @escaping (Result<[Product], APIError>) -> Void) {
        self.productService.fetchProducts(completion:completion)
    }
    
    func fetchUserProfile(completion: @escaping (Result<User, APIError>) -> Void) {
        self.UserService.fetchUserProfile(completion: completion)
    }
    
    func fetchFollowers(completion: @escaping (Result<[User], APIError>) -> Void) {
        self.UserService.fetchFollowers(completion: completion)
    }
    
    func fetchTags(completion: @escaping (Result<[Tag], APIError>) -> Void) {
        self.TagService.fetchTags(completion: completion)
    }
    
    
}
