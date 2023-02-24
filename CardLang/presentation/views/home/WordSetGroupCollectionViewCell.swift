//
//  WordSetGroupCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 24.02.2023.
//

import UIKit
import RealmSwift

class WordSetGroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var recentSets : Results<WordSet>?
    
    
    func configure(_ recentSets : Results<WordSet>){
        self.recentSets = recentSets
    }
}
