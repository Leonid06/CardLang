//
//  SliderItem.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation
import CardSlider

struct SliderItem : CardSliderItem {
    var image: UIImage
    
    var rating: Int?
    
    var title: String
    
    var subtitle: String?
    
    var description: String?
}
