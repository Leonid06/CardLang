//
//  HomeHorizontalCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 24.02.2023.
//

import UIKit

@IBDesignable
class SetHomeColllectionViewCell: UICollectionViewCell {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius}
    }
    
    private var set : WordSet?

    @IBOutlet weak var termsCountLabel: UILabel!
    @IBOutlet weak var setNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
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
}
