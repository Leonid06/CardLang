//
//  SingleSetCollectionViewController.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit
import RealmSwift

class SingleSetViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var translations = List<Translation>()
    
    private let setRepository = SetRepository.shared
    
    private let cardRepository =  CardRepository.shared
    
    var set :  WordSet? {
        didSet {
            if let translations = set?.translations {
                self.translations = translations
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTranslations()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
//        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        title = set?.name
        
        collectionView!.register(WordCollectionViewCell.nib(), forCellWithReuseIdentifier: Identifies.WordCollectionViewCellIdentifier)
        
        
        let buttonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
//        buttonItem.tintColor = UIColor(named: Colors.buttonColor)

        let playItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonPressed))
//        playItem.tintColor = UIColor(named: Colors.buttonColor)
        
        navigationItem.rightBarButtonItems = [buttonItem, playItem]
        
        
        setRepository.subscribeToUpdatesOnTranslations {
            self.updateTranslations()
        }
//        updateTranslations()
    }
    
    @objc func playButtonPressed(_ sender: Any) {
        let playController = CardViewController(nibName: NibNames.CardViewControllerNibName, bundle: nil )
        playController.set = set
        navigationController?.pushViewController(playController, animated: true)
    }

    
    
    @objc func addButtonPressed(_ sender: Any) {
        
        let addModeViewController = AddModeViewController(nibName: NibNames.AddModeViewControllerNibName, bundle: nil)
        
        if let set = set {
            addModeViewController.configure(set)
        }
//        let searchViewController = SearchViewController(nibName: NibNames.SearchViewControllerNibName , bundle: nil)
//        
//        if let set = set {
//            searchViewController.configure(set)
//        }
        
        navigationController?.pushViewController(addModeViewController, animated: true)
    }
    
    private func showAlert() {
       let alert = UIAlertController(title: "Add new word", message: nil, preferredStyle: .alert)
       
       alert.addTextField {
           textField in
           textField.placeholder = "Enter the word"
       }
       
       
       let addAction = UIAlertAction(title: "Add", style: .default){
           action in
           if let textFields = alert.textFields {
               if let name = textFields[0].text {
                   self.cardRepository.fetchTranslations(words: [name], completion: self.onTranslationsFetched)
               }
           }
       }
       let deleteAction =  UIAlertAction(title: "Cancel", style: .cancel){
           action in
           alert.dismiss(animated: true)
       }
       alert.addAction(addAction)
       alert.addAction(deleteAction)
       
       present(alert, animated: true)
   }
    
    
    private func onTranslationsFetched(translations : [Translation]){
        print("got \(translations.count) translations")
        if let set = self.set {
            self.setRepository.addTranslationToSet(set: set, translation: translations[0],completion: self.updateTranslations)
            
        }
    }
    
    private func updateTranslations(){
        self.translations = set?.translations ?? List<Translation>()
        collectionView.reloadData()
        
        navigationItem.rightBarButtonItems?[1].isHidden = translations.count == 0 ? true : false

    }

}


extension SingleSetViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(translations.count)
        return translations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.WordCollectionViewCellIdentifier, for: indexPath) as! WordCollectionViewCell
        
    
        cell.configure(translations[translations.count - 1 - indexPath.row])
    
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 
    }
}


extension SingleSetViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}


//gestures
//extension  SingleSetViewController {
//    private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
//
//        switch(gesture.state) {
//
//        case UIGestureRecognizer.State.began:
//            guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
//                break
//            }
//            collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
//        case UIGestureRecognizer.State.changed:
//            collectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
//        case UIGestureRecognizer.State.ended:
//            collectionView?.endInteractiveMovement()
//        default:
//            collectionView?.cancelInteractiveMovement()
//        }
//    }
//}


