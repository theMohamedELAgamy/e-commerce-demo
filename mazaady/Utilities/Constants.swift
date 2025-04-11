import UIKit

struct Constants {
    
    // MARK: - UI Constants
    struct UI {
        static let mainColor = UIColor(red: 0.16, green: 0.52, blue: 0.98, alpha: 1.0)
        static let lightGrayColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        static let darkGrayColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        static let starColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        
        static let cornerRadius: CGFloat = 8.0
        static let standardPadding: CGFloat = 16.0
        static let smallPadding: CGFloat = 8.0
    }
    
    // MARK: - String Constants
    struct Strings {
        // Common
        static let errorTitle = NSLocalizedString("error", comment: "Error alert title")
        static let okButton = NSLocalizedString("ok", comment: "OK button title")
        static let cancel = NSLocalizedString("cancel", comment: "Cancel button title")
        
        // Tab Bar
        static let profileTitle = NSLocalizedString("profile", comment: "Profile tab title")
        static let searchTitle = NSLocalizedString("search", comment: "Search tab title")
        
        // Profile
        static let products = NSLocalizedString("products", comment: "Products tab")
        static let articles = NSLocalizedString("articles", comment: "Articles tab")
        static let reviews = NSLocalizedString("reviews", comment: "Reviews tab")
        static let followers = NSLocalizedString("followers", comment: "Followers count")
        static let following = NSLocalizedString("following", comment: "Following count")
        static let settings = NSLocalizedString("settings", comment: "Settings button")
        
        // Search
        static let searchHint = NSLocalizedString("search_hint", comment: "Search placeholder")
        static let noResults = NSLocalizedString("no_results", comment: "No results found")
        static let tryAgain = NSLocalizedString("try_again", comment: "Try again button")
    }
    
    // MARK: - API Constants
    struct API {
        static let baseURL = "https://stagingapi.mazaady.com/api/interview-tasks"
        static let timeout: TimeInterval = 30.0
        
        // Endpoints
        static let profileEndpoint = "/user"
        static let productsEndpoint = "/products"
        static let tagsEndpoint = "/tags"
        static let reviewsEndpoint = "/reviews"
        static let adsEndpoint = "/advertisements"
        static let searchEndpoint = "/search"
    }
    
    // MARK: - Cache Keys
    struct CacheKeys {
        static let userProfile = "user_profile_cache"
        static let products = "products_cache"
        static let tags = "tags_cache"
        static let advertisements = "advertisements_cache"
        static let reviews = "reviews_cache"
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let language = "app_language"
        static let isFirstLaunch = "is_first_launch"
        static let userToken = "user_token"
        static let userId = "user_id"
        static let userLoginStatus = "user_login_status"
        static let lastSyncDate = "last_sync_date"
    }
    
    // MARK: - Notifications
    struct NotificationNames {
        static let languageChanged = "com.mazaady.languageChanged"
        static let userLoggedIn = "com.mazaady.userLoggedIn"
        static let userLoggedOut = "com.mazaady.userLoggedOut"
    }
}
