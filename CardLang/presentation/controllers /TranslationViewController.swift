//
//  TranslationViewController.swift
//  CardLang
//
//  Created by Leonid on 29.10.2022.
//

import UIKit


protocol PopUpControllerDelegate {
    func onDismissed()
}

class TranslationViewController: UIViewController {
    
    
    private let setRepository = SetRepository.shared
    
    var delegate : PopUpControllerDelegate?

    @IBOutlet weak var meaningTextField: AddTranslationTextField!
    @IBOutlet weak var termTextField: AddTranslationTextField!
    
    
    private var set : WordSet?
    
    
    
    func configure(_ set : WordSet){
        self.set = set
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func onTermAdded(){
//        if let viewController = navigationController?.viewControllers.first(where: {$0 is SingleSetViewController}) {
//            navigationController?.popToViewController(viewController, animated: true)
//        }
        dismiss(animated: true)
        delegate?.onDismissed()
    }


    @IBAction func addTermButtonClicked(_ sender: UIButton) {
        if let set = set  {
            if let term = termTextField.text, let meaning = meaningTextField.text {
                setRepository.addTranslationToSet(set: set, term: term, meaning: meaning){
                    self.onTermAdded()
                }
            }
        }
    }
    

}
