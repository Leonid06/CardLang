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
        
//        cardStack.frame.size.width = 300
//        cardStack.frame.size.height = 450
        
        NSLayoutConstraint.activate([
            cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardStack.widthAnchor.constraint(equalToConstant: 300),
            cardStack.heightAnchor.constraint(equalToConstant: 450),
        ])
        
//        let constraints = [
//            cardStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            cardStack.trailingAnchor.constraint(equalTo:
//                view.safeAreaLayoutGuide.trailingAnchor),
//            cardStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            cardStack.bottomAnchor.constraint(equalTo:
//                view.safeAreaLayoutGuide.bottomAnchor)
//        ]
//        
//        NSLayoutConstraint.activate(constraints)
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
        
//        let content = CardView.instantiate(text:  translation.word)
//        let content = CardView()
        let content = UINib(nibName: NibNames.CardViewNibName, bundle: nil).instantiate(withOwner: nil).first as! CardView
        
        let leftOverlay = UINib(nibName: NibNames.LeftOverlayViewNibName, bundle: nil).instantiate(withOwner: nil).first as! UIView
        
        let rightOverlay = UINib(nibName: NibNames.RightOverlayViewNibName, bundle: nil).instantiate(withOwner: nil).first as! UIView
        
//        leftOverlay.text = "Don't remember"
//        leftOverlay.font = leftOverlay.font.withSize(30)
//        leftOverlay.textColor = UIColor.systemRed
        
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        card.content = content
        card.translation = translation
        
        return card
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
          print("Number of translations : \(translations.count)")
          return translations.count
    }
}

extension CardViewController :  SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if(direction == SwipeDirection.left){
            skippedTranslations.append(translations[index])
        }
    }
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        translations = skippedTranslations
        if(skippedTranslations.isEmpty){
            navigationController?.popViewController(animated: true)
        }
        skippedTranslations.removeAll()
        updateTranslations()
    }
}
//callbacks





