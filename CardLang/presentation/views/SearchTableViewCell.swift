//
//  SearchTableViewCell.swift
//  CardLang
//
//  Created by Leonid on 23.09.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var translationLabel: UILabel!
    private var translation : Translation?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI(){
        translationLabel.text = translation?.translation
    }
    
    func configure(_ translation : Translation){
        self.translation = translation
        updateUI()
    }
    
}
