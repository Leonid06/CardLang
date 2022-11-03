//
//  Extensions.swift
//  CardLang
//
//  Created by Leonid on 31.10.2022.
//

import UIKit

extension SingleSetViewController {
    func getAddOptionsMenu() -> UIMenu {
        let menu = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Search a term", image: UIImage(systemName: "plus.magnifyingglass")){ action in
                self.navigateToSearchController()
            },
            UIAction(title: "Add your own term", image: UIImage(systemName: "plus.circle")){ action in
                self.navigateToAddController()
            }
        ])
        
        return menu
    }
    
    private func navigateToAddController() {
        let addOwnTranslationViewController = TranslationViewController(nibName: NibNames.TranslationViewControllerNibName, bundle: nil)
        
        if let set = set {
            addOwnTranslationViewController.configure(set)
        }
        
        if let sheet = addOwnTranslationViewController.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.preferredCornerRadius = 24
        }
        
        addOwnTranslationViewController.delegate = self
        
        
        self.present(addOwnTranslationViewController, animated: true)
    }
    private func navigateToSearchController() {
        let searchViewController = SearchViewController(nibName: NibNames.SearchViewControllerNibName , bundle: nil)

        if let set = set {
            searchViewController.configure(set)
        }
        
        if let sheet = searchViewController.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.preferredCornerRadius = 24
        }
        
        searchViewController.delegate = self 
        
        
        self.present(searchViewController, animated: true)
    }
}





