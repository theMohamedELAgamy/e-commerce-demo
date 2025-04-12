import UIKit

class AdvertisementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    


    
    // MARK: - Configuration
    func configure(with advertisement: Advertisement) {
     
         let imageUrl = advertisement.imageUrl
        iconImageView.loadImage(from: imageUrl)
        
    
    }
    
}
