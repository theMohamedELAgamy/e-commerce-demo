import UIKit

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    func addShadow(ofColor color: UIColor = UIColor.black, radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    // Add a tap gesture to a view
    func addTapGesture(target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    

    
    // Set specific rounded corners
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
    }
    
    // Apply gradient
    func applyGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0), endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Support for RTL layouts
    func flipForRTL() {
        if LocalizationHelper.shared.isRTL {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.transform = .identity
        }
    }
}

extension UIView {
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.1, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
    
    func roundCorners(radius: CGFloat = 8) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func addBorder(color: UIColor = .lightGray, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    class func fromNib<T: UIView>() -> T {
        let bundleName = Bundle(for: T.self)
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: bundleName)
        
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Could not load view from nib named: \(nibName)")
        }
        
        return view
    }
}
