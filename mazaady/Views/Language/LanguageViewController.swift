import UIKit

class LanguageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!
    
    // MARK: - Properties
    private var viewModel: LanguageViewModelProtocol!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
        setupTableView()
        bindViewModel()
    }
    
    // MARK: - Setup
    private func setupViewModel() {
        viewModel = LanguageViewModel()
    }
    
    private func setupUI() {
        // Configure navigation bar
        title = "language".localized
        titleLabel.text = "language".localized
        
        // Configure close button
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        // Register cell nib
        tableView.register(
            UINib(nibName: "LanguageTableViewCell", bundle: nil),
            forCellReuseIdentifier: "LanguageCell"
        )
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure table view
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        // Bind languages
        viewModel.languages.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        // Bind current language
        viewModel.currentLanguageCode.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LanguageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.languages.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageTableViewCell
        
        let language = viewModel.languages.value[indexPath.row]
        let isSelected = language.code == viewModel.currentLanguageCode.value
        
        cell.configure(with: language, isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedLanguage = viewModel.languages.value[indexPath.row]
        viewModel.setLanguage(selectedLanguage.code)
        
        // Close the view controller after changing language
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
