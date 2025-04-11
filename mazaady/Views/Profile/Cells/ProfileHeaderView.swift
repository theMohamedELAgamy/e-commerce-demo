import UIKit

class ProfileHeaderView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var followersCountLabel: UILabel!
    @IBOutlet private weak var followingCountLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var followingLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure profile image
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        // Set up labels with localized text
        followersLabel.text = "followers".localized
        followingLabel.text = "following".localized
        
        // Apply styles
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        usernameLabel.font = UIFont.systemFont(ofSize: 14)
        usernameLabel.textColor = .gray
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        locationLabel.textColor = .gray
        
        followersCountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        followingCountLabel.font = UIFont.boldSystemFont(ofSize: 16)
        followersLabel.font = UIFont.systemFont(ofSize: 12)
        followersLabel.textColor = .gray
        followingLabel.font = UIFont.systemFont(ofSize: 12)
        followingLabel.textColor = .gray
    }
    
    // MARK: - Configuration
    func configure(with user: User) {
        // Set user data
        nameLabel.text = user.name
        usernameLabel.text = user.username
        locationLabel.text = user.location ?? "location".localized
        
        // Set counts
        followersCountLabel.text = "\(user.followersCount)"
        followingCountLabel.text = "\(user.followingCount)"
        
        // Load profile image if available
        if let imageUrl = user.profileImage {
            profileImageView.loadImage(from: imageUrl)
        } else {
            // Set placeholder image
            profileImageView.image = UIImage(named: "placeholder")
        }
        
        // Support for RTL if needed
        if LocalizationHelper.shared.isRTL {
            setupRTLLayout()
        } else {
            setupLTRLayout()
        }
    }
    
    private func setupRTLLayout() {
        // Adjust layout for RTL languages if needed
        followersLabel.textAlignment = .right
        followingLabel.textAlignment = .right
    }
    
    private func setupLTRLayout() {
        // Default layout for LTR languages
        followersLabel.textAlignment = .center
        followingLabel.textAlignment = .center
    }
    
    // MARK: - Helper Methods
    class func fromNib() -> ProfileHeaderView {
        return Bundle.main.loadNibNamed("ProfileHeaderView", owner: nil, options: nil)?.first as! ProfileHeaderView
    }
}
