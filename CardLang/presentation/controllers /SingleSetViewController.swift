//
//  SingleSetCollectionViewController.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit
import RealmSwift

class SingleSetViewController: UICollectionViewController {
    
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
        
        title = set?.name
        
        collectionView!.register(UINib(nibName: NibNames.WordCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.WordCollectionViewCellIdentifier)
        
        let buttonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        
        navigationItem.rightBarButtonItem = buttonItem
        updateTranslations()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @objc func addButtonPressed(_ sender: Any) {
        showAlert()
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
            self.setRepository.addTranslationToSet(set: set, translation: translations[0])
            self.translations = set.translations
            print(set.translations.count)
            self.updateTranslations()
        }
    }
    
    private func updateTranslations(){
        collectionView.reloadData()
    }
    
    
    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension SingleSetViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.width / 2)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(translations.count)
        return translations.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.WordCollectionViewCellIdentifier, for: indexPath) as! WordCollectionViewCell
        
    
        cell.translation = translations[indexPath.row]
    
        return cell
    }
}
