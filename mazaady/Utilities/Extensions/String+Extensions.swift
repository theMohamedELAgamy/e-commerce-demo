import Foundation
import UIKit

extension String {
    

    
    // Check if string is a valid email
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // Check if string is a valid phone number
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: self)
    }
    
    // Format price string
    func formatPrice() -> String {
        guard let doubleValue = Double(self) else { return self }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: doubleValue)) ?? self
    }
    
    // Calculate the size of text with a specific font
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, 
                                           options: .usesLineFragmentOrigin, 
                                           attributes: [NSAttributedString.Key.font: font], 
                                           context: nil)
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, 
                                           options: .usesLineFragmentOrigin, 
                                           attributes: [NSAttributedString.Key.font: font], 
                                           context: nil)
        return boundingBox.width
    }
    
    // Truncate string to a certain number of characters
    func truncate(to length: Int, trailing: String = "...") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    // Convert HTML string to attributed string
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, 
                                         options: [.documentType: NSAttributedString.DocumentType.html, 
                                                  .characterEncoding: String.Encoding.utf8.rawValue], 
                                         documentAttributes: nil)
        } catch {
            print("Error converting HTML to attributed string: \(error)")
            return nil
        }
    }
}
