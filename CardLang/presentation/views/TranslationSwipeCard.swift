//
//  TranslationSwipeView.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import Foundation
import Shuffle_iOS


class TranslationSwipeCard : SwipeCard {
    
    var translation : Translation? {
        didSet {
            shuffleMode = defaultsRepository.getShuffleMode()
            
            showsWord = shuffleMode == .showTerms ? true : false
            
            if let translation = translation {
                if let content = content as? CardView {
                    content.wordLabel.text = showsWord ? translation.word : translation.translation
                }
            }
        }
    }
    
    private let defaultsRepository = DefaultsRepository.shared
    
    private var shuffleMode : ShuffleMode?
    
    private var showsWord  = true
    
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
                    self.showsWord = !self.showsWord
                    content.wordLabel.text = self.showsWord ? translation.word : translation.translation
                }
            }
        }
    }
}
