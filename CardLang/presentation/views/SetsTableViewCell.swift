//
//  SetsTableViewCell.swift
//  CardLang
//
//  Created by Leonid on 01.09.2022.
//

import UIKit

class SetsTableViewCell: UITableViewCell {

    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
