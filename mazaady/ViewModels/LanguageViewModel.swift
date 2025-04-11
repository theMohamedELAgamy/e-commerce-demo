import Foundation

// Protocol for language view model
protocol LanguageViewModelProtocol: ViewModelProtocol {
    var languages: Observable<[Language]> { get }
    var currentLanguageCode: Observable<String> { get }
    
    func setLanguage(_ languageCode: String)
    func getCurrentLanguage() -> Language?
}

// Language model
struct Language {
    let code: String
    let name: String
    let nativeName: String
    let isRTL: Bool
}

// Language view model implementation
class LanguageViewModel: BaseViewModel, LanguageViewModelProtocol {
    
    var languages: Observable<[Language]> = Observable([])
    var currentLanguageCode: Observable<String> = Observable(LocalizationHelper.shared.currentLanguage)
    
    override init() {
        super.init()
        setupLanguages()
    }
    
    // Setup available languages
    private func setupLanguages() {
        let languages = [
            Language(
                code: "en",
                name: "English",
                nativeName: "English",
                isRTL: false
            ),
            Language(
                code: "ar",
                name: "Arabic",
                nativeName: "العربية",
                isRTL: true
            )
        ]
        
        self.languages.value = languages
    }
    
    // Set app language
    func setLanguage(_ languageCode: String) {
        guard languageCode != currentLanguageCode.value else { return }
        
        LocalizationHelper.shared.changeLanguage(to: languageCode)
        currentLanguageCode.value = languageCode
    }
    
    // Get current language
    func getCurrentLanguage() -> Language? {
        return languages.value.first { $0.code == currentLanguageCode.value }
    }
}
