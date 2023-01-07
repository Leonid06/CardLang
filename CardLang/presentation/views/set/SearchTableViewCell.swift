//
//  SearchTableViewCell.swift
//  CardLang
//
//  Created by Leonid on 23.09.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var wordTypeLabel: UILabel!
    
    private var translation : Translation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI(){
        translationLabel.text = translation?.translation
        wordTypeLabel.text = translation?.type
        
        if let text = wordTypeLabel.text {
            adjustFontColor(type: text)
        }
    }
    
    func configure(_ translation : Translation){
        self.translation = translation
        updateUI()
    }
    
    private func adjustFontColor(type : String){
        switch type {
        case "adverb":
            wordTypeLabel.textColor = UIColor.systemPurple
        case "adjective":
            wordTypeLabel.textColor = UIColor.systemBlue
        case "verb":
            wordTypeLabel.textColor = UIColor.systemPink
        default:
            wordTypeLabel.textColor = UIColor.systemGreen
        }
    }
    
}
