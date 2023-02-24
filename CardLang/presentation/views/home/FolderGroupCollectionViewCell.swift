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
    
    func configure(_ recentFolders : Results<Folder>){
        self.recentFolders = recentFolders
    }
}
