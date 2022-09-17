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
    
    private var translations = List<Translation>()
    
    private let cardRepository = CardRepository()
    
    
    private let cardStack = SwipeCardStack()
    
    var set :  WordSet? {
        didSet {
            if let translations = set?.translations {
                self.translations = translations
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTranslations()
        layoutCardStackView()
        cardStack.dataSource = self
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
        let content = UINib(nibName: NibNames.CardViewNibName, bundle: nil).instantiate(withOwner: self).first as! CardView
        
        content.wordLabel.text = translation.word
        card.content = content
        card.translation = translation
        
        return card
    }

    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
          print("Number of translations : \(translations.count)")
          return translations.count
    }
}
//callbacks





