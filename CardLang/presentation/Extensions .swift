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

extension String {
    static func removeTokens(string : String) -> String {
        
        var temporaryString = string
        var isFound = false
        var firstIndex : Index = temporaryString.startIndex
        var secondIndex : Index = temporaryString.startIndex
    
        
        
        for (index, char) in temporaryString.enumerated() {
            if !char.isLetter {
                if(isFound){
                    secondIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
                    let range = Range(uncheckedBounds: (lower: firstIndex, upper: secondIndex))
                    temporaryString.removeSubrange(firstIndex ..< secondIndex)
                    isFound = false
                }else {
                    firstIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
                    isFound = true
                }
            }
        }
        
        return temporaryString
    }
}

