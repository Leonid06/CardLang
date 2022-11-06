//
//  CardView.swift
//  CardLang
//
//  Created by Leonid on 31.08.2022.
//

import UIKit


@IBDesignable
class CardView: UIView {

    
    @IBOutlet weak var wordLabel: UILabel!
    
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius     }
    }
    
    static func instantiate(text: String) -> CardView {
        let view: CardView = initFromNib()
        view.wordLabel.text = text
        return view
       }
}
