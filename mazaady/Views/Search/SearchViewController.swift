import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateView: UIView!
    @IBOutlet private weak var emptyStateLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var viewModel: ProductListViewModelProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupCollectionView()
        setupSearchBar()
        bindViewModel()
        
        // Initial data loading
        viewModel.fetchProducts()
    }
    
    // MARK: - Setup
    private func setupViewModel() {
        viewModel = ProductListViewModel()
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
    
    private func setupSearchBar() {
        searchBar.placeholder = Constants.Strings.searchHint
        searchBar.delegate = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // Create two-column grid layout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Item size
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(300)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            // Group and section setup
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(300)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
            
            return section
        }
        
        return layout
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Bind products
        viewModel.products.bind { [weak self] products in
            guard let self = self else { return }
            
            self.collectionView.reloadData()
            self.updateEmptyState(isEmpty: products.isEmpty)
        }
        
        // Bind loading state
        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
        
        // Bind error message
        viewModel.errorMessage.bind { [weak self] message in
            guard let self = self, let message = message, !message.isEmpty else { return }
            self.showAlert(title: Constants.Strings.errorTitle, message: message)
        }
    }
    
    // MARK: - UI Updates
    private func updateEmptyState(isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        
        if isEmpty {
            if !viewModel.searchQuery.value.isEmpty {
                emptyStateLabel.text = "No products found for '\(viewModel.searchQuery.value)'"
            } else {
                emptyStateLabel.text = Constants.Strings.noResults
            }
        }
    }
    
    // MARK: - Helper Methods
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.okButton, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        
        if let product = viewModel.getProductAt(index: indexPath.item) {
            cell.configure(with: product)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle product selection (simplified for demo)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        // Search products
        viewModel.searchProducts(text)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Reset search results when text is cleared
            viewModel.fetchProducts()
        }
    }
}
