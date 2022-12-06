//
//  FolderTableViewCell.swift
//  CardLang
//
//  Created by Leonid on 04.12.2022.
//

import UIKit

@IBDesignable
class FolderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius}
    }
}
