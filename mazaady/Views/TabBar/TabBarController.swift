import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    private var profileViewController: ProfileViewController!
    private var searchViewController: SearchViewController!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupAppearance()
    }
    
    // MARK: - Setup
    private func setupViewControllers() {
        // Create view controllers
        profileViewController = ProfileViewController()
        searchViewController = SearchViewController()
        
        // Setup navigation controllers
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        
        // Configure navigation items
        profileViewController.title = Constants.Strings.profileTitle
        searchViewController.title = Constants.Strings.searchTitle
        
        // Set tab bar items
        profileNavController.tabBarItem = UITabBarItem(
            title: Constants.Strings.profileTitle,
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        searchNavController.tabBarItem = UITabBarItem(
            title: Constants.Strings.searchTitle,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        // Set view controllers
        viewControllers = [profileNavController, searchNavController]
    }
    
    private func setupAppearance() {
        // Customize tab bar appearance
        tabBar.tintColor = Constants.UI.mainColor
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        // Add shadow to tab bar
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowRadius = 4
    }
}