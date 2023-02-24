//
//  FolderHomeCollectionViewCell.swift
//  CardLang
//
//  Created by Leonid on 24.02.2023.
//

import UIKit

class FolderHomeCollectionViewCell: UICollectionViewCell {
    private var folder : Folder?
    
    @IBOutlet weak var setsCountLabel: UILabel!
    @IBOutlet weak var folderNameLabel: UILabel!
    func configure(_ folder: Folder){
        self.folder = folder 
    }
    
    private func configureUI(){
        if let folder = folder {
            folderNameLabel.text = folder.name
            setsCountLabel.text = "\(folder.sets.count) terms"
        }
    }
}
