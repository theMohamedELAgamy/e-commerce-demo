import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var highestBidLabel: UILabel!
    @IBOutlet private weak var highestBidValueLabel: UILabel!
    @IBOutlet private weak var offerPriceLabel: UILabel!
    @IBOutlet private weak var offerPriceValueLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    private var isFavorite = false
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        highestBidValueLabel.text = nil
        offerPriceValueLabel.text = nil
        statusLabel.isHidden = true
        isFavorite = false
        updateFavoriteButton()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure container view
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        containerView.addShadow(ofColor: .gray, radius: 3, offset: CGSize(width: 0, height: 1), opacity: 0.2)
        
        // Configure product image
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        
        // Configure status label
        statusLabel.layer.cornerRadius = 4
        statusLabel.clipsToBounds = true
        statusLabel.backgroundColor = Constants.UI.mainColor
        statusLabel.textColor = .white
        statusLabel.font = UIFont.boldSystemFont(ofSize: 10)
        statusLabel.textAlignment = .center
        statusLabel.isHidden = true
        
        // Configure favorite button
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        updateFavoriteButton()
        
        // Configure text labels
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 2
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel.textColor = Constants.UI.mainColor
        
        highestBidLabel.text = "highest_bid".localized
        highestBidLabel.font = UIFont.systemFont(ofSize: 12)
        highestBidLabel.textColor = UIColor.gray
        
        highestBidValueLabel.font = UIFont.systemFont(ofSize: 12)
        highestBidValueLabel.textColor = UIColor.black
        
        offerPriceLabel.text = "offer_price".localized
        offerPriceLabel.font = UIFont.systemFont(ofSize: 12)
        offerPriceLabel.textColor = UIColor.gray
        
        offerPriceValueLabel.font = UIFont.systemFont(ofSize: 12)
        offerPriceValueLabel.textColor = UIColor.black
    }
    
    private func updateFavoriteButton() {
        let imageName = isFavorite ? "heart-filled" : "heart"
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        updateFavoriteButton()
        
        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // MARK: - Configuration
    func configure(with product: Product) {
        // Set product data
        nameLabel.text = product.name
        priceLabel.text = "\(product.price)"
        
        // Set highest bid if available
         let highestBid = product.price
            highestBidValueLabel.text = "\(highestBid)"
      
        
        // Set offer price if available
         let offerPrice = product.price
            offerPriceValueLabel.text = "\(offerPrice)"
       
        
        // Set auction status
   
        
        // Load image if available
         let imageUrl = product.image 
            productImageView.loadImage(from: imageUrl)
//        } else {
//            productImageView.image = UIImage(named: "placeholder")
//        }
        
        // Support for RTL if needed
        if LocalizationHelper.shared.isRTL {
            setupRTLLayout()
        }
    }
    
    private func setupRTLLayout() {
        // Adjust layout for RTL languages if needed
        nameLabel.textAlignment = .right
        priceLabel.textAlignment = .right
        highestBidLabel.textAlignment = .right
        highestBidValueLabel.textAlignment = .right
        offerPriceLabel.textAlignment = .right
        offerPriceValueLabel.textAlignment = .right
    }
}
