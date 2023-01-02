//
//  AddSetToFolderCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 19.12.2022.
//

import UIKit

class AddSetToFolderCollectionViewCell: UICollectionViewCell {
    
    
    private var set: WordSet?
    
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var termCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    private func updateUI(){
        if let set = set {
            setNameLabel.text = set.name
            termCountLabel.text = "\(set.translations.count) terms"
        }
    }
    
    
    func configure(_ set: WordSet?){
        self.set = set
        updateUI()
    }

}
