//
//  AddSetToFolderViewController.swift
//  CardLang
//
//  Created by Leonid on 18.12.2022.
//

import UIKit
import RealmSwift

class AddSetToFolderViewController: UIViewController {
    
    private let setRepository  =  SetRepository.shared
    private let folderRepository = FolderRepository.shared
    
    private var sets: Results<WordSet>?
    private var folder: Folder?
    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier)
        
        
        setRepository.subscribeToUpdatesOnSets {
            self.updateSets()
        }
    }
    
    func configure(_ folder: Folder){
        self.folder = folder
    }
    
    private func updateSets(){
        Task {
            self.sets = try await setRepository.getUnfolderedSets()
            self.collectionView.reloadData()
        }
    }
}

extension AddSetToFolderViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sets = sets, let folder = folder  {
            let set = sets[sets.count - 1 - indexPath.row]
            folderRepository.addSetToFolder(set: set, folder: folder){
                self.dismiss(animated: true)
            }
            
        }
    }
}

extension AddSetToFolderViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sets = sets {
            return sets.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier, for: indexPath) as! SingleFolderCollectionViewCell
    
        if let sets = sets {
                let set = sets[sets.count - 1 - indexPath.row]
                cell.configure(set)
            }
    
        return cell
    }
}

extension AddSetToFolderViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 40, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
