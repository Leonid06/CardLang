//
//  WordCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var wordLabel: UILabel!
    
    private var showsWord = true
    
    
    private var translation : Translation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 10
        
        let gestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(flip))
        gestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func flip(_ sender: UIGestureRecognizer){
        let options : UIView.AnimationOptions = [.transitionFlipFromRight]
        UIView.transition(with: self, duration: 0.5, options: options){
            if let translation = self.translation {
                    self.wordLabel.text = self.showsWord ? translation.translation : translation.word
                    self.showsWord = !self.showsWord
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: NibNames.WordCollectionViewCellNibName, bundle: nil)
    }
    
    func configure(_ translation:Translation) {
        self.translation = translation
        wordLabel.text = self.translation?.word
     }
}
