//
//  FoldersViewController.swift
//  CardLang
//
//  Created by Leonid on 04.12.2022.
//

import UIKit
import RealmSwift

class FoldersViewController: UIViewController {
    
    private let folderRepository = FolderRepository.shared
    
    private var folders  : Results<Folder>?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyState.format = getEmptyStateFormat()
        collectionView.register(UINib(nibName: NibNames.FolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.FolderCollectionViewCellIdentifier)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }
        folderRepository.subscribeOnUpdatesOnFolders {
            self.updateFolders()
        }
    }
    @IBAction func addFolderButtonClicked(_ sender: Any) {
        let createFolderViewController = CreateFolderViewController(nibName: NibNames.CreateFolderViewControllerNibName, bundle: nil)
        
        createFolderViewController.modalPresentationStyle = .overFullScreen
        present(createFolderViewController, animated: true)
    }
    
    private func foldersAreEmpty() -> Bool {
        return folders?.isEmpty ?? true
    }
    
    private func updateEmptyState(){
        if foldersAreEmpty() {
            collectionView.emptyState.show(EmptyState.noFolders)
            return
        }
        collectionView.emptyState.hide()
    }
    
    private func updateFolders() {
        Task {
            do {
                self.folders = try await self.folderRepository.getAllFolders()
                self.collectionView.reloadData()
                updateEmptyState()
            }catch {
                print(error)
            }
        }
    }
}


extension FoldersViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let folders = folders {
            let folder = folders[folders.count - 1 - indexPath.section]
            
            let singleFolderViewController = SingleFolderViewController(nibName: NibNames.SingleFolderViewControllerNibName, bundle: nil)
            
            singleFolderViewController.configure(folder)
            
            navigationController?.pushViewController(singleFolderViewController, animated: true)
        }
    }
}

extension FoldersViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let folders = folders {
            if(folders.count == 0){
                collectionView.emptyState.show(EmptyState.noFolders)
            }else {
                collectionView.emptyState.hide()
            }
            return folders.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifies.FolderCollectionViewCellIdentifier, for: indexPath) as! FolderCollectionViewCell
    
            if let folders = folders {
                let folder = folders[folders.count - 1 - indexPath.section]
                cell.configure(folder)
            }
    
            return cell
    }
}

extension FoldersViewController : UICollectionViewDelegateFlowLayout  {
    
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
