import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Properties
    private var isCellSelected = false
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        setSelected(false)
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure container view
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        // Configure name label
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor.darkGray
        nameLabel.textAlignment = .center
    }
    
    // MARK: - Configuration
    func configure(with tag: Tag) {
        nameLabel.text = tag.name.localized
    }
    
    func setSelected(_ selected: Bool) {
        isCellSelected = selected
        
        if selected {
            containerView.backgroundColor = Constants.UI.mainColor.withAlphaComponent(0.2)
            containerView.layer.borderColor = Constants.UI.mainColor.cgColor
            nameLabel.textColor = Constants.UI.mainColor
            nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        } else {
            containerView.backgroundColor = UIColor.white
            containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            nameLabel.textColor = UIColor.darkGray
            nameLabel.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.containerView.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }
}
