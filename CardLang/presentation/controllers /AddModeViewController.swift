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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchTermButtonClicked(_ sender: Any) {
        let searchViewController = SearchViewController(nibName: NibNames.SearchViewControllerNibName , bundle: nil)

        if let set = set {
            searchViewController.configure(set)
        }
        
        navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func addOwnTermbuttonClicked(_ sender: Any) {
        let addOwnTranslationViewController = TranslationViewController(nibName: NibNames.TranslationViewControllerNibName, bundle: nil)
        
        if let set = set {
            addOwnTranslationViewController.configure(set)
        }
        
        navigationController?.pushViewController(addOwnTranslationViewController, animated: true)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
