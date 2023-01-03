//
//  UIViewController.swift
//  CardLang
//
//  Created by Leonid on 22.12.2022.
//

import Foundation
import UIKit



extension UIViewController {
    func createBarButtonItem(icon: String, selector: Selector?, menu : UIMenu? = nil) -> UIBarButtonItem {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        button.setImage(UIImage(systemName: icon), for: .normal)
        if let selector = selector {
            button.addTarget(self, action: selector, for: .touchUpInside)
        }
   
       
        button.imageView?.contentMode = .scaleAspectFit

        let buttonBarButton = UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25)))
        buttonBarButton.customView?.addSubview(button)
        buttonBarButton.customView?.frame = button.frame
        
        if let menu = menu {
            button.menu = menu
            button.showsMenuAsPrimaryAction = true
        }
        return buttonBarButton
    }
}
