//
//  SingleFolderCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 17.12.2022.
//

import UIKit

class SingleFolderCollectionViewCell: UICollectionViewCell {
    
    private var set: WordSet?
    @IBOutlet weak var termsCountLabel: UILabel!
    @IBOutlet weak var setNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(_ set: WordSet){
        self.set = set
        configureUI()
    }
    
    private func configureUI(){
        if let set = set {
            setNameLabel.text = set.name
            termsCountLabel.text = "\(set.translations.count) terms"
        }
    }
    

   
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius}
    }

}
