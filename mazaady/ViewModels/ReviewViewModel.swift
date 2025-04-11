import Foundation

// Protocol for review view model
protocol ReviewViewModelProtocol {
    var userName: String { get }
    var rating: Int { get }
    var comment: String? { get }
    var dateString: String { get }
    var userImageUrl: String? { get }
}

// Review view model implementation
class ReviewViewModel: ReviewViewModelProtocol {
    
    private let review: Review
    
    init(review: Review) {
        self.review = review
    }
    
    var userName: String {
        return review.userName
    }
    
    var rating: Int {
        return Int(review.rating)
    }
    
    var comment: String? {
        return review.comment
    }
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = dateFormatter.date(from: review.date) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
    var userImageUrl: String? {
        return review.userProfileImage
    }
}
