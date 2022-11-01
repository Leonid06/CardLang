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
        
        title = set?.name
        
        collectionView!.register(WordCollectionViewCell.nib(), forCellWithReuseIdentifier: Identifies.WordCollectionViewCellIdentifier)
        
        
        let buttonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self,action: nil)
        buttonItem.menu = getAddOptionsMenu()

        let playItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonPressed))
        
        
        
        navigationItem.rightBarButtonItems = [buttonItem, playItem]
        
        
        
        
        
        setRepository.subscribeToUpdatesOnTranslations {
            self.updateTranslations()
        }
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateTranslations()
        }
    }
    
    @objc func playButtonPressed(_ sender: Any) {
        let playController = CardViewController(nibName: NibNames.CardViewControllerNibName, bundle: nil)
        playController.set = set
        navigationController?.pushViewController(playController, animated: true)
    }

    
    
    private func onTranslationsFetched(translations : [Translation]){
        print("got \(translations.count) translations")
        if let set = self.set {
            self.setRepository.addTranslationToSet(set: set, translation: translations[0],completion: {})
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let translation = translations[translations.count - 1 - indexPath.row]
        
        let termViewController = TermViewController(nibName: NibNames.TermViewControllerNibName, bundle: nil)
        
        if let set = self.set {
            termViewController.configure(translation, set)
        }
        
        present(termViewController, animated: true, completion: nil)
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





