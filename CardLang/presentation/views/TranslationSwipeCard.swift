//
//  TranslationSwipeView.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import Foundation
import Shuffle_iOS


class TranslationSwipeCard : SwipeCard {
    
    var translation : Translation?
    
    private var showsWord = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(flip))
        gestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureRecognizer)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func flip(_ sender: UIGestureRecognizer){
        let options : UIView.AnimationOptions = [.transitionFlipFromRight]
        UIView.transition(with: self, duration: 0.5, options: options){
            if let translation = self.translation {
                if let content = self.content as? CardView {
                    content.wordLabel.text = self.showsWord ? translation.translation : translation.word
                    self.showsWord = !self.showsWord
                }
            }
        }
    }
    
    
}
