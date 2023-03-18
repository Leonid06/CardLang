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
        

        recentCollectionView.delegate = self
        recentCollectionView.dataSource = self
        
        recentCollectionView.register(UINib(nibName: NibNames.FolderGroupCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.FolderGroupCollectionViewCellIdentifier)
        recentCollectionView.register(UINib(nibName: NibNames.WordSetGroupCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.WordSetGroupCollectionViewCellIdentifier)
        
        homeRepository.getRecentlyVisitedWordSets(completion: onRecentWordSetsFetched)
        homeRepository.getRecentlyVisitedFolders(completion: onRecentFoldersFetched)
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
        return CGSize(width: 360, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 10)
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
        return 1 
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
        default: return WordSetGroupCollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}
