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
    
    
    private var _translation : Translation?
    var translation : Translation  {
        set {
            _translation = newValue
        }
        get {
            return _translation ?? Translation(word: "", translation: "")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(flip))
        gestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureRecognizer)
        
        wordLabel.text = _translation?.word
    }
    
    @objc private func flip(_ sender: UIGestureRecognizer){
        let options : UIView.AnimationOptions = [.transitionFlipFromRight]
        UIView.transition(with: self, duration: 0.5, options: options){
            if let translation = self._translation {
                    self.wordLabel.text = self.showsWord ? translation.translation : translation.word
                    self.showsWord = !self.showsWord
            }
        }
    }
}
