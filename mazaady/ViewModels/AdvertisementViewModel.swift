import Foundation

// Protocol for advertisement view model
protocol AdvertisementViewModelProtocol {
    var imageUrl: String? { get }
}

// Advertisement view model implementation
class AdvertisementViewModel: AdvertisementViewModelProtocol {
    
    private let advertisement: Advertisement
    
    init(advertisement: Advertisement) {
        self.advertisement = advertisement
    }
    

    

    var imageUrl: String? {
        return advertisement.imageUrl
    }
    

}
