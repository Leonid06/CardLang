//
//  AddTranslationTextField.swift
//  CardLang
//
//  Created by Leonid on 29.10.2022.
//

import Foundation
import UIKit


@IBDesignable
class AddTranslationTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    private func sharedInit() {
        borderStyle = .none

        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.borderWidth = 0.6
        layer.cornerRadius = 4
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).insetBy(dx: 8, dy: 0)
    }
}


