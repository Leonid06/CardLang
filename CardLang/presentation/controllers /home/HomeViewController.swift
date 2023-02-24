//
//  HomeViewController.swift
//  CardLang
//
//  Created by Leonid on 24.02.2023.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    private let homeRepository = HomeRepository.shared
    
    private var recentSets : Results<WordSet>?
    private var recentFolders: Results<Folder>?

    @IBOutlet weak var recentCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeRepository.getRecentlyVisitedFolders(completion: onRecentFoldersFetched)
        homeRepository.getRecentlyVisitedWordSets(completion: onRecentWordSetsFetched)
        
        
        recentCollectionView.register(UINib(nibName: NibNames.FolderGroupCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.FolderGroupCollectionViewCellIdentifier)
        recentCollectionView.register(UINib(nibName: NibNames.WordSetGroupCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.WordSetGroupCollectionViewCellIdentifier)
    }
    
    private func onRecentWordSetsFetched(recentSets: Results<WordSet>?) {
        self.recentSets = recentSets
        recentCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    private func onRecentFoldersFetched(recentFolders: Results<Folder>?) {
        self.recentFolders = recentFolders
        recentCollectionView.reloadSections(IndexSet(integer: 1))
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let recentSets = recentSets {
                return recentSets.count
            }
            return 0
        case 1:
            if let recentFolders = recentFolders {
                return recentFolders.count
            }
            return 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.WordSetGroupCollectionViewCellIdentifier, for: indexPath) as! WordSetGroupCollectionViewCell
            if let recentSets = recentSets {
                cell.configure(recentSets)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.FolderGroupCollectionViewCellIdentifier, for: indexPath) as! FolderGroupCollectionViewCell
            if let recentFolders = recentFolders {
                cell.configure(recentFolders)
            }
            return cell 
        default: return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
}
