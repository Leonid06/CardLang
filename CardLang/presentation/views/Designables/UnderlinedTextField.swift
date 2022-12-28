//
//  UnderlinedTextField.swift
//  CardLang
//
//  Created by Leonid on 25.12.2022.
//

import UIKit


@IBDesignable
class UnderlinedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        setUnderLine()
    }
    private func setUnderLine() {
           let border = CALayer()
           let width = CGFloat(0.5)
           border.borderColor = UIColor(named: "secondaryGreyLabelColor")?.cgColor
           border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
           border.borderWidth = width
           self.layer.addSublayer(border)
           self.layer.masksToBounds = true
       }
}
