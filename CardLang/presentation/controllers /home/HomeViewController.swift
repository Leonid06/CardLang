//
//  HomeViewController.swift
//  CardLang
//
//  Created by Leonid on 24.02.2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var recentCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 129)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 40, bottom: 30, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource  {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////
////    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////
////    }
//}
