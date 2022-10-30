//
//  TranslationViewController.swift
//  CardLang
//
//  Created by Leonid on 29.10.2022.
//

import UIKit

class TranslationViewController: UIViewController {
    
    
    private let setRepository = SetRepository.shared

    @IBOutlet weak var meaningTextField: AddTranslationTextField!
    @IBOutlet weak var termTextField: AddTranslationTextField!
    
    
    private var _set : WordSet?
    
    var set  : WordSet? {
        didSet {
            _set = set
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func onTermAdded(){
        navigationController?.popViewController(animated: true)
    }


    @IBAction func addTermButtonClicked(_ sender: UIButton) {
        if let set = _set  {
            if let term = termTextField.text, let meaning = meaningTextField.text {
                setRepository.addTranslationToSet(set: set, term: term, meaning: meaning){
                    
                }
            }
        }
    }
    

}
