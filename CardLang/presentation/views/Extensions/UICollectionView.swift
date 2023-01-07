//
//  UICollectionView.swift
//  CardLang
//
//  Created by Leonid on 05.01.2023.
//

import UIKit
import Differ


extension UICollectionView {
    func reloadChanges<T: Collection>(from old: T, to new: T) where T.Element: Equatable {
        animateItemChanges(oldData: old, newData: new, updateData: {})
    }
}
