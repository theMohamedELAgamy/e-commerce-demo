import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet weak var offerPriceLabl: UILabel!
    @IBOutlet weak var originalPriceLabl: UILabel!
    @IBOutlet weak var offerPriceStack: UIStackView!
    @IBOutlet weak var daysDate: UILabel!
    @IBOutlet weak var hourseDate: UILabel!
    @IBOutlet weak var minutesDate: UILabel!
    @IBOutlet weak var offerEndTimeStack: UIStackView!
    // MARK: - Properties
    
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

        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 2
        
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
    }
    
    

    // MARK: - Configuration
    func configure(with product: Product) {
        // Set product data
        nameLabel.text = product.name
        priceLabel.text = "\(product.price)"
        
        let imageUrl = product.image
        productImageView.loadImage(from: imageUrl)
        if let date=product.endDate {
            offerEndTimeStack.isHidden=false
            let timeComponents=convertSecondsToTimeComponents(date)
            daysDate.text="\(timeComponents.days)"
            hourseDate.text="\(timeComponents.hours)"
            minutesDate.text="\(timeComponents.minutes)"
        }else{
            offerEndTimeStack.isHidden=true
        }
        
        if let offer = product.offer{
            originalPriceLabl.setStrikethroughText("\(product.price)")
            offerPriceLabl.text="\(offer)"
            offerPriceStack.isHidden=false
        }else{
            offerPriceStack.isHidden=true
        }
        
        if LocalizationHelper.shared.isRTL {
            setupRTLLayout()
        }
    }
    
    private func setupRTLLayout() {
        // Adjust layout for RTL languages if needed
        nameLabel.textAlignment = .right
        priceLabel.textAlignment = .right
    }
    
    private func convertSecondsToTimeComponents(_ seconds: Double) -> TimeComponents {
        let totalMinutes = Int(seconds) / 60
        let days = totalMinutes / (24 * 60)
        let hours = (totalMinutes % (24 * 60)) / 60
        let minutes = totalMinutes % 60
        
        return TimeComponents(days: days, hours: hours, minutes: minutes)
    }
}
fileprivate struct TimeComponents {
    let days: Int
    let hours: Int
    let minutes: Int
}
extension UILabel {
    func setStrikethroughText(_ text: String, color: UIColor = .gray) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: color
        ]
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

