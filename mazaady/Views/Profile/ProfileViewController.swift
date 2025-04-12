// MARK: - Main ViewController

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Section Types
    enum SectionType: Int, CaseIterable {
        case products = 0
        case advertisements = 1
        case tags = 2
        
        var title: String {
            switch self {
            case .tags: return "Top Tags"
            case .advertisements: return "Featured"
            case .products: return "Products"
            }
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var profileHeaderContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabsContainerView: UIView!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var articlesButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var segmentIndicator: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: ProfileViewModelProtocol!
    private var profileHeaderView: ProfileHeaderView!
    private let sections: [SectionType] = SectionType.allCases
    private var layoutFactory: CollectionViewLayoutFactoryProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupLayoutFactory()
        setupProfileHeaderView()
        setupCollectionView()
        setupTabsView()
        setupSearch()
        
        bindViewModel()
        
        // Initial data loading
        loadData()
    }
    
    // MARK: - Setup
    private func setupViewModel() {
        viewModel = ProfileViewModel(profileUseCase: ProfileUseCase(productService: ProductService(), UserService: UserService(), TagService: TagService(), advertisementService: AdvertisementService()))
    }
    
    private func setupLayoutFactory() {
        layoutFactory = ProfileCollectionViewLayoutFactory()
    }
    
    private func setupProfileHeaderView() {
        profileHeaderView = ProfileHeaderView.fromNib()
        profileHeaderView.frame = profileHeaderContainerView.bounds
        profileHeaderContainerView.addSubview(profileHeaderView)
        
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileHeaderView.topAnchor.constraint(equalTo: profileHeaderContainerView.topAnchor),
            profileHeaderView.leadingAnchor.constraint(equalTo: profileHeaderContainerView.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: profileHeaderContainerView.trailingAnchor),
            profileHeaderView.bottomAnchor.constraint(equalTo: profileHeaderContainerView.bottomAnchor)
        ])
        
        // Settings button action
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        // Register all cells using the factory
        CellProviderFactory.registerAllCells(for: collectionView)
        
        // Set up compositional layout using our factory
        collectionView.collectionViewLayout = layoutFactory.createLayout()
        
        // Set delegates
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Add some insets around the collection view
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        
        // Always show the vertical scroller for better UX
        collectionView.alwaysBounceVertical = true
        
        // Set background color
        collectionView.backgroundColor = .white
    }
    
    private func setupTabsView() {
        // Set up tab buttons
        productsButton.setTitle(Constants.Strings.products, for: .normal)
        articlesButton.setTitle(Constants.Strings.articles, for: .normal)
        reviewsButton.setTitle(Constants.Strings.reviews, for: .normal)
        
        // Add actions to tab buttons
        productsButton.addTarget(self, action: #selector(productsTapped), for: .touchUpInside)
        articlesButton.addTarget(self, action: #selector(articlesTapped), for: .touchUpInside)
        reviewsButton.addTarget(self, action: #selector(reviewsTapped), for: .touchUpInside)
        
        // Style the indicator
        segmentIndicator.backgroundColor = Constants.UI.mainColor
        segmentIndicator.layer.cornerRadius = 2
        
        // Default selection
        updateTabSelection(index: 0)
    }
    
    private func setupSearch() {
        searchBar.placeholder = Constants.Strings.searchHint
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.autocapitalizationType = .none
        searchBar.returnKeyType = .search
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Bind user data
        viewModel.user.bind { [weak self] user in
            guard let self = self, let user = user else { return }
            self.profileHeaderView.configure(with: user)
        }
        
        // Bind products, tags, and advertisements
        viewModel.products.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: SectionType.products.rawValue))
        }
        
        viewModel.tags.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: SectionType.tags.rawValue))
        }
        
        viewModel.advertisements.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: SectionType.advertisements.rawValue))
        }
        
        // Bind error message
        viewModel.errorMessage.bind { [weak self] message in
            guard let message = message, !message.isEmpty else { return }
            self?.showAlert(title: Constants.Strings.errorTitle, message: message)
        }
        
        // Bind loading state
        viewModel.isLoading.bind { [weak self] isLoading in
            // Show/hide loading indicator (simplified for demo)
        }
        
        // Bind tab selection
        viewModel.selectedTabIndex.bind { [weak self] index in
            self?.updateTabSelection(index: index)
        }
    }
    
    // MARK: - Data Loading
    private func loadData() {
        viewModel.fetchUserProfile()
        viewModel.fetchProducts()
        viewModel.fetchTags()
        viewModel.fetchAdvertisements()
    }
    
    // MARK: - UI Updates
    private func updateTabSelection(index: Int) {
        // Update buttons appearance
        productsButton.setTitleColor(index == 0 ? Constants.UI.mainColor : .gray, for: .normal)
        articlesButton.setTitleColor(index == 1 ? Constants.UI.mainColor : .gray, for: .normal)
        reviewsButton.setTitleColor(index == 2 ? Constants.UI.mainColor : .gray, for: .normal)
        
        // Calculate indicator position
        let buttons = [productsButton, articlesButton, reviewsButton]
        let selectedButton = buttons[index]
        
        UIView.animate(withDuration: 0.3) {
            self.segmentIndicator.center.x = selectedButton!.center.x+15
        }
        
        // Load relevant data based on the selected tab
        switch index {
        case 0:
            collectionView.isHidden=false
            searchBar.isHidden=false
            viewModel.fetchProducts()
        case 1:
            collectionView.isHidden=true
            searchBar.isHidden=true
        case 2:
            collectionView.isHidden=true
            searchBar.isHidden=true

        default:
            break
        }
    }
    
    // MARK: - Actions
    @objc private func productsTapped() {
        viewModel.setSelectedTab(index: 0)
    }
    
    @objc private func articlesTapped() {
        viewModel.setSelectedTab(index: 1)
    }
    
    @objc private func reviewsTapped() {
        viewModel.setSelectedTab(index: 2)
    }
    
    @objc private func settingsButtonTapped() {
        // Open settings/language view (simplified for demo)
        let alert = UIAlertController(title: "Settings", message: "Language settings would open here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.okButton, style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.okButton, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        
        switch sectionType {
        case .tags:
            return viewModel.tags.value.count
        case .advertisements:
            return viewModel.advertisements.value.count
        case .products:
            return viewModel.products.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        let provider = CellProviderFactory.provider(for: sectionType)
        
        let cell = type(of: provider).dequeueReusableCell(for: collectionView, at: indexPath)
        
        switch sectionType {
        case .tags:
            if indexPath.item < viewModel.tags.value.count {
                provider.configureCell(cell, with: viewModel.tags.value[indexPath.item])
            }
        case .advertisements:
            if indexPath.item < viewModel.advertisements.value.count {
                provider.configureCell(cell, with: viewModel.advertisements.value[indexPath.item])
            }
        case .products:
            if indexPath.item < viewModel.products.value.count {
                provider.configureCell(cell, with: viewModel.products.value[indexPath.item])
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderCell",
                for: indexPath
            )
            
            // Remove any existing label
            headerView.subviews.forEach { $0.removeFromSuperview() }
            
            // Create section title label
            let titleLabel = UILabel()
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textColor = .black
            titleLabel.text = sections[indexPath.section].title
            
            // Add to header view
            headerView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
        case .tags:
            if indexPath.item < viewModel.tags.value.count {
                let tag = viewModel.tags.value[indexPath.item]
                // Handle tag selection
                print("Selected tag: \(tag.name)")
            }
            
        case .advertisements:
            if indexPath.item < viewModel.advertisements.value.count {
                let advertisement = viewModel.advertisements.value[indexPath.item]
                // Handle advertisement selection
            }
            
        case .products:
            if indexPath.item < viewModel.products.value.count {
                let product = viewModel.products.value[indexPath.item]
                // Handle product selection
                print("Selected product: \(product.name)")
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension ProfileViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            viewModel.fetchProducts()
            return
        }
         viewModel.searchProducts(query: text)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchProducts()
        } else if searchText.count > 2 {
             viewModel.searchProducts(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchProducts()
        searchBar.resignFirstResponder()
    }
}
