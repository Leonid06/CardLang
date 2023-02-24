//
//  FolderGroupCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 24.02.2023.
//

import UIKit
import RealmSwift

class FolderGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var recentFolders : Results<Folder>?
    
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: NibNames.FolderHomeCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.FolderHomeCollectionViewCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configure(_ recentFolders : Results<Folder>){
        self.recentFolders = recentFolders
    }
}

extension FolderGroupCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let recentFolders = recentFolders {
            return recentFolders.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let recentFolders = recentFolders {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.FolderHomeCollectionViewCellIdentifier, for: indexPath) as! FolderHomeCollectionViewCell
            
            cell.configure(recentFolders[indexPath.row])
        }
        return UICollectionViewCell()
    }
}
