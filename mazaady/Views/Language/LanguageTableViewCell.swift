import UIKit

class LanguageTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nativeNameLabel: UILabel!
    @IBOutlet private weak var checkmarkImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        nativeNameLabel.text = nil
        checkmarkImageView.isHidden = true
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure labels
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.black
        
        nativeNameLabel.font = UIFont.systemFont(ofSize: 14)
        nativeNameLabel.textColor = UIColor.gray
        
        // Configure checkmark
        checkmarkImageView.tintColor = Constants.UI.mainColor
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        
        // General cell setup
        selectionStyle = .none
        accessoryType = .none
    }
    
    // MARK: - Configuration
    func configure(with language: Language, isSelected: Bool) {
        nameLabel.text = language.name
        nativeNameLabel.text = language.nativeName
        checkmarkImageView.isHidden = !isSelected
        
        // Apply highlight if selected
        contentView.backgroundColor = isSelected ? Constants.UI.mainColor.withAlphaComponent(0.1) : .white
        
        // Support for RTL if needed
        if language.isRTL {
            setupRTLLayout()
        } else {
            setupLTRLayout()
        }
    }
    
    private func setupRTLLayout() {
        // Adjust layout for RTL languages if needed
        nameLabel.textAlignment = .right
        nativeNameLabel.textAlignment = .right
    }
    
    private func setupLTRLayout() {
        // Default layout for LTR languages
        nameLabel.textAlignment = .left
        nativeNameLabel.textAlignment = .left
    }
}
