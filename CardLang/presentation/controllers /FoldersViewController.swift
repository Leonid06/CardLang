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
        collectionView.register(UINib(nibName: NibNames.FolderCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifies.FolderCollectionViewCellIdentifier)
        
        
        folderRepository.subscribeOnUpdatesOnFolders {
            self.updateFolders()
        }
    }
    @IBAction func addFolderButtonClicked(_ sender: Any) {
        let createFolderViewController = CreateFolderViewController(nibName: NibNames.CreateFolderViewControllerNibName, bundle: nil)
        
        createFolderViewController.modalPresentationStyle = .overFullScreen
        present(createFolderViewController, animated: true)
    }
    
    private func updateFolders() {
        Task {
            do {
                self.folders = try await self.folderRepository.getAllFolders()
                self.collectionView.reloadData()
            }catch {
                print(error)
            }
        }
    }
}


extension FoldersViewController : UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
}

extension FoldersViewController : UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let folders = folders {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
