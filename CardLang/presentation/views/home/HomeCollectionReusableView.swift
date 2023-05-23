//
//  HomeCollectionReusableView.swift
//  CardLang
//
//  Created by Leonid on 19.03.2023.
//

import UIKit

class HomeCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var sectionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ label : String){
        self.sectionLabel.text = label 
    }
}
