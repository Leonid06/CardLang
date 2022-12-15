//
//  FolderCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 15.12.2022.
//

import UIKit

@IBDesignable
class FolderCollectionViewCell: UICollectionViewCell {
    
    private var folder : Folder?
    
    
    @IBOutlet weak var folderNameLabel: UILabel!
    
    private func setLabel(){
        folderNameLabel.text = folder?.name
        
//        if let numberOfSets = folder?.sets.count {
//            setsCountLabel.text = "\(numberOfSets)"
//        }
        
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
