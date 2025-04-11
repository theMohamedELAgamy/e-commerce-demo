import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var profileHeaderContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabsContainerView: UIView!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var articlesButton: UIButton!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var segmentIndicator: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    @IBOutlet weak var adsContainerView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: ProfileViewModelProtocol!
    private var profileHeaderView: ProfileHeaderView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupProfileHeaderView()
        setupCollectionView()
        setupTabsView()
        setupSearch()
        setupTagsCollectionView()
        setupAdvertisementsView()
        
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
            forCellWithReuseIdentifier: "ProductCell"
        )
        
        // Set up compositional layout
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        // Set delegates
        collectionView.delegate = self
        collectionView.dataSource = self
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
    }
    
    private func setupTagsCollectionView() {
        // Register cell nibs
        tagsCollectionView.register(
            UINib(nibName: "TagCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "TagCell"
        )
        
        // Set up horizontal scrolling layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.minimumLineSpacing = 8
        tagsCollectionView.collectionViewLayout = layout
        
        // Set delegates
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
    }
    
    private func setupAdvertisementsView() {
        // Setup advertisement views (simplified for demo)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // Create two-column grid layout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Item size
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                 heightDimension: .estimated(300))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            // Group and section setup
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
            
            return section
        }
        
        return layout
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Bind user data
        viewModel.user.bind { [weak self] user in
            guard let self = self, let user = user else { return }
            self.profileHeaderView.configure(with: user)
        }
        
        // Bind products
        viewModel.products.bind { [weak self] _ in
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
        
        // Bind tags
        viewModel.tags.bind { [weak self] _ in
            self?.tagsCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.products.value.count
        } else if collectionView == tagsCollectionView {
            return viewModel.tags.value.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
            
            let product = viewModel.products.value[indexPath.item]
            cell.configure(with: product)
            
            return cell
        } else if collectionView == tagsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCollectionViewCell
            
            let tag = viewModel.tags.value[indexPath.item]
            cell.configure(with: tag)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle cell selection
        collectionView.deselectItem(at: indexPath, animated: true)
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
        viewModel.products.value = viewModel.products.value.filter { product in
            return product.name.lowercased().contains(text.lowercased())
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.fetchProducts()
        }
    }
}
