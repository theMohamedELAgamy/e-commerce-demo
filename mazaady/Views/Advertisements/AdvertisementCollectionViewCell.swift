import UIKit

class AdvertisementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        iconImageView.image = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure container view
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        // Apply gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [
            UIColor(red: 0.78, green: 0.20, blue: 0.36, alpha: 1.0).cgColor,
            UIColor(red: 0.65, green: 0.15, blue: 0.28, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Configure labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        
        // Configure icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update gradient frame when layout changes
        if let gradientLayer = containerView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = containerView.bounds
        }
    }
    
    // MARK: - Configuration
    func configure(with advertisement: Advertisement) {
     
         let imageUrl = advertisement.imageUrl
        iconImageView.loadImage(from: imageUrl)
        
        
        // Support for RTL if needed
        if LocalizationHelper.shared.isRTL {
            setupRTLLayout()
        }
    }
    
    private func setupRTLLayout() {
        // Adjust layout for RTL languages if needed
        titleLabel.textAlignment = .right
        descriptionLabel.textAlignment = .right
    }
}
