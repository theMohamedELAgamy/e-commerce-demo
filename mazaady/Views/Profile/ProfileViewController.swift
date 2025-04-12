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
    
    // MARK: - Cell Identifiers
    private enum CellIdentifier {
        static let productCell = "ProductCell"
        static let tagCell = "TagCell"
        static let advertisementCell = "AdvertisementCell"
        static let headerCell = "HeaderCell"
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
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
        viewModel = ProfileViewModel()
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
        // Register cell nibs
        collectionView.register(
            UINib(nibName: "ProductCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.productCell
        )
        
        collectionView.register(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.tagCell
        )
        
        collectionView.register(
            UINib(nibName: "AdvertisementCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.advertisementCell
        )
        
        // Register header
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CellIdentifier.headerCell
        )
        
        // Set up compositional layout
        collectionView.collectionViewLayout = createCompositionalLayout()
        
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
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let sectionType = self.sections[sectionIndex]
            
            switch sectionType {
            case .tags:
                return self.createTagsSection()
            case .advertisements:
                return self.createAdvertisementsSection()
            case .products:
                return self.createProductsSection()
            }
        }
        
        return layout
    }
    
    private func createTagsSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(120),
            heightDimension: .absolute(40)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(12)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top:0, leading: 16, bottom: 24, trailing: 16)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func createAdvertisementsSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 0)
        
    
        
        return section
    }
    
    private func createProductsSection() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .estimated(280)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(290)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 8)
        
        // Header
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return section
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
            self?.collectionView.reloadData()
        }
        
        viewModel.tags.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.advertisements.bind { [weak self] _ in
            self?.collectionView.reloadData()
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
            self.segmentIndicator.center.x = selectedButton!.center.x
            self.segmentIndicator.frame.size.width = selectedButton!.frame.width / 2
        }
        
        // Load relevant data based on the selected tab
        switch index {
        case 0:
            viewModel.fetchProducts()
        case 1:
            // For articles tab - not implemented in this demo
            break
        case 2:
            viewModel.fetchReviews()
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
        
        switch sectionType {
        case .tags:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.tagCell, for: indexPath) as! TagCollectionViewCell
            if indexPath.item < viewModel.tags.value.count {
                let tag = viewModel.tags.value[indexPath.item]
                cell.configure(with: tag)
            }
            return cell
            
        case .advertisements:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.advertisementCell, for: indexPath) as! AdvertisementCollectionViewCell
            if indexPath.item < viewModel.advertisements.value.count {
                let advertisement = viewModel.advertisements.value[indexPath.item]
                cell.configure(with: advertisement)
            }
            return cell
            
        case .products:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.productCell, for: indexPath) as! ProductCollectionViewCell
            if indexPath.item < viewModel.products.value.count {
                let product = viewModel.products.value[indexPath.item]
                cell.configure(with: product)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CellIdentifier.headerCell,
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
        
        // Search products
//        viewModel.searchProducts(query: text)
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchProducts()
        } else if searchText.count > 2 {
            // Perform search if user has typed at least 3 characters
//            viewModel.searchProducts(query: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchProducts()
        searchBar.resignFirstResponder()
    }
}
