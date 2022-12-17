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
    
    
    @IBOutlet weak var setsCountLabel: UILabel!
 
    @IBOutlet weak var folderNameLabel: UILabel!
    
    private func setLabel(){
        folderNameLabel.text = folder?.name
        
        if let numberOfSets = folder?.sets.count {
            setsCountLabel.text = "\(numberOfSets) sets"
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
