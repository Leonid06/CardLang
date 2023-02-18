//
//  UIViewController.swift
//  CardLang
//
//  Created by Leonid on 22.12.2022.
//

import UIKit
import EmptyStateKit




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
    
    
    func displayAlert(title: String, message: String, dismissButtonTitle: String){
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
              
        let dismissAlertAction = UIAlertAction(title: dismissButtonTitle, style: .default)
        alertController.addAction(dismissAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayDialog(title : String, message: String, firstOptionTitle: String, secondOptionTitle: String, firstCompletion: @escaping () -> Void, secondCompletion: @escaping ()-> Void){
        let dialogMessage = UIAlertController(title: title, message:message, preferredStyle: .alert)
              
        let firstOption = UIAlertAction(title: firstOptionTitle, style: .default, handler: { _ in firstCompletion()})
        let secondOption = UIAlertAction(title: secondOptionTitle, style: .cancel) { _ in secondCompletion()}
              
        dialogMessage.addAction(firstOption)
        dialogMessage.addAction(secondOption)
              
        present(dialogMessage, animated: true, completion: nil)
    }
    
    func getEmptyStateFormat() -> EmptyStateFormat {
        var format = EmptyStateFormat()
        format.titleAttributes = [.font: UIFont.systemFont(ofSize: 17), .foregroundColor : UIColor(named: "wordLabelColor") ?? UIColor()]
        format.descriptionAttributes = [.font: UIFont.systemFont(ofSize: 15) , .foregroundColor : UIColor(named: "secondaryGreyLabelColor") ?? UIColor()]
        
        return format
    }
}
