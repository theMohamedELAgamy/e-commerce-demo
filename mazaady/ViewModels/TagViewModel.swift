import Foundation

// Protocol for tag view model
protocol TagViewModelProtocol {
    var name: String { get }
    var iconUrl: String? { get }
}

// Tag view model implementation
class TagViewModel: TagViewModelProtocol {
    
    private let tag: Tag
    
    init(tag: Tag) {
        self.tag = tag
    }
    
    var name: String {
        return tag.name
    }
    
 
    
    var iconUrl: String? {
        return tag.name
    }
}
