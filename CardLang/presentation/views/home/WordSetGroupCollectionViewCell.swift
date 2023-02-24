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
    
    
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: NibNames.SetHomeCollectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Identifiers.SetHomeCollectionViewCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    func configure(_ recentSets : Results<WordSet>){
        self.recentSets = recentSets
    }
}


extension WordSetGroupCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let recentSets = recentSets {
            return recentSets.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let recentSets = recentSets {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.SetHomeCollectionViewCellIdentifier, for: indexPath) as! SetHomeColllectionViewCell
            
            cell.configure(recentSets[indexPath.row])
        }
        return UICollectionViewCell()
    }
}
