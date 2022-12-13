//
//  FolderTableViewCell.swift
//  CardLang
//
//  Created by Leonid on 04.12.2022.
//

import UIKit

@IBDesignable
class FolderTableViewCell: UITableViewCell {

    @IBOutlet weak var setsCountLabel: UILabel!
    @IBOutlet weak var folderNameLabel: UILabel!
    
    private var folder : Folder?
    
    
    private func setLabel(){
        folderNameLabel.text = folder?.name
        
        if let numberOfSets = folder?.sets.count {
            setsCountLabel.text = "\(numberOfSets)"
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    
    func configure(_ folder : Folder){
        self.folder = folder
        setLabel()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius}
    }
}
