//
//  ViewController.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import UIKit
import CardSlider
import Shuffle_iOS
import RealmSwift

class CardViewController: UIViewController {
    
    private var translations = [Translation]()
    
    private var skippedTranslations = [Translation]()
    
    private let cardRepository = CardRepository.shared
    

    private let cardStack = SwipeCardStack()
    
    var set :  WordSet? {
        didSet {
            if let translations = set?.translations {
                self.translations = Array(translations.shuffled())
            }
        }
    }
    
    
    @IBOutlet weak var learnedCountLabel: UILabel!
    @IBOutlet weak var skippedCountLabel: UILabel!
    
    private var learnedCount = 0
    private var skippedCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTranslations()
        layoutCardStackView()
        cardStack.dataSource = self
        cardStack.delegate = self
    }
    
    private func layoutCardStackView() {
        view.addSubview(cardStack)
        
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardStack.widthAnchor.constraint(equalToConstant: 300),
            cardStack.heightAnchor.constraint(equalToConstant: 450),
        ])
      }
    
    private func updateTranslations(){
        cardStack.reloadData()
    }
}

extension CardViewController : SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = TranslationSwipeCard()
        let translation = translations[index]
        
        card.swipeDirections = [.left, .right]
        
        let content = UINib(nibName: NibNames.CardViewNibName, bundle: nil).instantiate(withOwner: nil).first as! CardView
        
        let leftOverlay = UINib(nibName: NibNames.LeftOverlayViewNibName, bundle: nil).instantiate(withOwner: nil).first as! UIView
        
        let rightOverlay = UINib(nibName: NibNames.RightOverlayViewNibName, bundle: nil).instantiate(withOwner: nil).first as! UIView
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        card.content = content
        card.translation = translation
        
        return card
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
          return translations.count
    }
}

extension CardViewController :  SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if(direction == .left){
            skippedCount += 1
            skippedCountLabel.text = String(skippedCount)
            
            skippedTranslations.append(translations[index])
        }
        if(direction == .right){
            learnedCount += 1
            learnedCountLabel.text = String(learnedCount)
        }
    }
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        translations = skippedTranslations
        if(skippedTranslations.isEmpty){
            navigationController?.popViewController(animated: true)
        }
        skippedTranslations.removeAll()
        updateTranslations()
        
        skippedCount = 0 
        skippedCountLabel.text = String(skippedCount)
    }
}






