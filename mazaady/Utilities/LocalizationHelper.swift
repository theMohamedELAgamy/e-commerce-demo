import Foundation
import UIKit

class LocalizationHelper {
    
    static let shared = LocalizationHelper()
    
    private init() {}
    
    // Current language code
    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.language) ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKeys.language)
            UserDefaults.standard.synchronize()
        }
    }
    
    // Check if current language is RTL
    var isRTL: Bool {
        return currentLanguage == "ar"
    }
    
    // Sets the initial language based on device settings or defaults to English
    func setInitialLanguage() {
        if UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.language) == nil {
            let preferredLanguage = Locale.preferredLanguages.first?.prefix(2).description ?? "en"
            currentLanguage = (preferredLanguage == "ar") ? "ar" : "en"
        }
        
        applyCurrentLanguageDirection()
    }
    
    // Changes the app language and updates UI direction
    func changeLanguage(to language: String) {
        guard currentLanguage != language else { return }
        
        currentLanguage = language
        applyCurrentLanguageDirection()
        
        // Post notification to update UI elements that depend on language

        NotificationCenter.default.post(name: NSNotification.Name(Constants.NotificationNames.languageChanged), object: nil)
        
        // Restart app to apply language changes
        restartApp()
    }
    
    // Apply RTL or LTR semantic based on current language
    private func applyCurrentLanguageDirection() {
        let semanticContentAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        
        UIView.appearance().semanticContentAttribute = semanticContentAttribute
        UINavigationBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITabBar.appearance().semanticContentAttribute = semanticContentAttribute
        UISearchBar.appearance().semanticContentAttribute = semanticContentAttribute
        UITextField.appearance().semanticContentAttribute = semanticContentAttribute
    }
    
    // Restart app to apply language changes
    private func restartApp() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let tabBarController = TabBarController()
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
    }
}
