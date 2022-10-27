//
//  Extensions .swift
//  CardLang
//
//  Created by Leonid on 31.08.2022.
//

import Foundation
import UIKit





extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
}

extension UISearchBar {
    func setPlaceholderColor(_ color: UIColor) {
        let textField = self.value(forKey: "searchField") as? UITextField
        let placeholder = textField!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.textColor = color
    }
    
    func setIconColor(_ color: UIColor) {
            for subView in self.subviews {
                for subSubView in subView.subviews {
                    let view = subSubView as? UITextInputTraits
                    if view != nil {
                        let textField = view as? UITextField
                        let glassIconView = textField?.leftView as? UIImageView
                        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
                        glassIconView?.tintColor = color
                        break
                    }
                }
            }
        }
}



//extension String {
//    static func removeTokens(string : String) -> String {
//
//        var temporaryString = string
//        var isFound = false
//        var firstIndex : Index = temporaryString.startIndex
//        var secondIndex : Index = temporaryString.startIndex
//
//
//
//        for (index, char) in temporaryString.enumerated() {
//            if !char.isLetter {
//                if(isFound){
//                    secondIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
//                    let range = Range(uncheckedBounds: (lower: firstIndex, upper: secondIndex))
//                    temporaryString.removeSubrange(firstIndex ..< secondIndex)
//                    isFound = false
//                }else {
//                    firstIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
//                    isFound = true
//                }
//            }
//        }
//
//        return temporaryString
//    }
//}

