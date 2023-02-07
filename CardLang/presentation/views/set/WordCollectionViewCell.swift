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
    }
    
    override func prepareForReuse() {
        showsWord = true
    }
    
    private func setLabel(){
        wordLabel.text = showsWord ? translation?.word : translation?.translation
    }
    
    @objc private func flip(_ sender: UIGestureRecognizer){
        let options : UIView.AnimationOptions = [.transitionFlipFromRight]
        UIView.transition(with: self, duration: 0.5, options: options){
            if let translation = self.translation {
                self.showsWord = !self.showsWord
                self.wordLabel.text = self.showsWord ? translation.word : translation.translation
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: NibNames.WordCollectionViewCellNibName, bundle: nil)
    }
    
    func configure(_ translation:Translation) {
        self.translation = translation
        setLabel()
     }
}
