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

