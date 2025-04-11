import Foundation
import Combine

// Base protocol for all view models
protocol ViewModelProtocol: AnyObject {
    var errorMessage: Observable<String?> { get }
    var isLoading: Observable<Bool> { get }
}

// Base view model implementation
class BaseViewModel: ViewModelProtocol {
    
    var errorMessage: Observable<String?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    
    // Handle errors uniformly
    func handleError(_ error: APIError) {
        isLoading.value = false
        errorMessage.value = error.localizedDescription
    }
}

