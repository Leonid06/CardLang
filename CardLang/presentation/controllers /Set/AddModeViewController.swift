//
//  AddModeViewController.swift
//  CardLang
//
//  Created by Leonid on 30.10.2022.
//

import UIKit

class AddModeViewController: UIViewController {
    
    
    private var set : WordSet?
    
    func configure(_ set : WordSet){
        self.set = set
    }
    
  

   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func searchTermButtonClicked(_ sender: Any) {
        let searchViewController = SearchViewController(nibName: NibNames.SearchViewControllerNibName , bundle: nil)

        if let set = set {
            searchViewController.configure(set)
        }
        
        if let sheet = searchViewController.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.preferredCornerRadius = 24
        }
        
        self.present(searchViewController, animated: true)
    }
    
    @IBAction func addOwnTermbuttonClicked(_ sender: Any) {
        let addOwnTranslationViewController = TranslationViewController(nibName: NibNames.TranslationViewControllerNibName, bundle: nil)
        
        if let set = set {
            addOwnTranslationViewController.configure(set)
        }
        
        if let sheet = addOwnTranslationViewController.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.preferredCornerRadius = 24
        }
        self.present(addOwnTranslationViewController, animated: true)
    }
}


