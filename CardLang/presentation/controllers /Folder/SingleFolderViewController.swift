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
    
    private let folderRepository = FolderRepository.shared
    
    private var folder : Folder?
    
    private var sets : List<WordSet>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: NibNames.SingleFolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.SingleFolderCollectionViewCellIdentifier)
        
        folderRepository.subscribeOnUpdatesOnFolders {
            if let folder = self.folder {
                if(!folder.isInvalidated){
                    self.updateSets()
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            
        }
        
        
        let addBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .add, target: self,action: #selector(onAddBarButtonClicked))
        
        let editBarButtonItem = createBarButtonItem(icon: "ellipsis", selector: #selector(onEditBarButtonClicked))
        
        navigationItem.rightBarButtonItems = [editBarButtonItem, addBarButtonItem]
        
        title = folder?.name
        
    }
    
    
    func configure(_ folder: Folder){
        self.folder = folder 
    }
    
    
    private func updateSets(){
        Task {
            self.sets = folder?.sets ?? List<WordSet>()
            self.collectionView.reloadData()
        }
        
        title = folder?.name
    }
    
    
    @objc func onEditBarButtonClicked(_ sender: Any){
        
        if let folder = folder {
            let editFolderViewController = EditFolderViewController(nibName: NibNames.EditFolderViewControllerNibName, bundle: nil)
            
            editFolderViewController.modalPresentationStyle = .overFullScreen
            
            editFolderViewController.configure(folder)
            
            present(editFolderViewController, animated: true)
        }
    }
    
    @objc func onAddBarButtonClicked(_ sender: Any){
        
        if let folder = folder {
            let addSetToFolderViewController = AddSetToFolderViewController(nibName: NibNames.AddSetToFolderViewCOntrollerNibName, bundle: nil)
            
            addSetToFolderViewController.configure(folder)
            
            addSetToFolderViewController.modalPresentationStyle = .overFullScreen
            
            present(addSetToFolderViewController, animated: true)
        }
        
    }
}

extension SingleFolderViewController : UICollectionViewDataSource {
    
    
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
    
        if let sets = folder?.sets {
            let set = sets[sets.count - 1 - indexPath.row]
                cell.configure(set)
            }
    
        return cell
    }
}

extension SingleFolderViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sets = sets {
            let set = sets[sets.count - 1 - indexPath.row]
            
            let mainStoryBoard = UIStoryboard(name: NibNames.MainStoryboardName, bundle: nil)
            
            let singleSetViewController = mainStoryBoard.instantiateViewController(withIdentifier: Identifies.SingleSetViewControllerIdentifier) as! SingleSetViewController
            
            singleSetViewController.set = set
            
            navigationController?.pushViewController(singleSetViewController, animated: true)
        }
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
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
