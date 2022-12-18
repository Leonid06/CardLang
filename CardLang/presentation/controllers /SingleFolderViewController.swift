//
//  SingleFolderViewController.swift
//  CardLang
//
//  Created by Leonid on 17.12.2022.
//

import UIKit
import RealmSwift

class SingleFolderViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let setRepository = SetRepository.shared
    
    private var folder : Folder?
    
    private var sets : List<WordSet>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier)
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateSets()
        }
        
        let addBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self,action: nil)
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func configure(_ folder: Folder){
        self.folder = folder 
    }
    
    
    private func updateSets(){
        Task {
            self.sets = folder?.sets ?? List<WordSet>()
            self.collectionView.reloadData()
        }
    }
}

extension SingleFolderViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sets = folder?.sets {
            return sets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier, for: indexPath) as! SingleFolderCollectionViewCell
    
        if let sets = folder?.sets {
                let set = sets[sets.count - 1 - indexPath.section]
                cell.configure(set)
            }
    
        return cell
    }
}

extension SingleFolderViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
