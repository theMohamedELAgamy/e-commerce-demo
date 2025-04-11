import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String?, placeholder: UIImage? = UIImage(named: "placeholder")) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        self.image = placeholder
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }.resume()
    }
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func applyShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2
        self.layer.masksToBounds = false
    }
    
    // For caching images
    func loadImageWithCache(from urlString: String, placeholder: UIImage? = UIImage(named: "placeholder")) {
        let cacheKey = NSString(string: urlString)
        
        // Check if image exists in cache
        if let cachedImage = ImageCache.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        // If not, download it
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        self.image = placeholder
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data) {
                    // Store in cache
                    ImageCache.shared.setObject(downloadedImage, forKey: cacheKey)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}

// Image Cache
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
