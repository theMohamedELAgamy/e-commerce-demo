import Foundation

// Protocol for product view model
protocol ProductViewModelProtocol {
    var name: String { get }
    var price: String { get }
    var highestBid: String? { get }
    var offerPrice: String? { get }
    var imageUrl: String? { get }
    var isAuctionFinished: Bool { get }
    
    func formatPrice(_ price: Double) -> String
}

// Product view model implementation
class ProductViewModel: ProductViewModelProtocol {
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var name: String {
        return product.name
    }
    
    var price: String {
        return formatPrice(product.price)
    }
    
    var highestBid: String? {
         let highestBid = product.price
        return formatPrice(highestBid)
    }
    
    var offerPrice: String? {
        let offerPrice = product.price 
        return formatPrice(offerPrice)
    }
    
    var imageUrl: String? {
        return product.image
    }
    
    var isAuctionFinished: Bool {
        return true
    }
    
    // Format price with EGP currency
    func formatPrice(_ price: Double) -> String {
        return "\(price) \("egp".localized)"
    }
}
