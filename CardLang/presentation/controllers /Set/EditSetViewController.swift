//
//  EditSetViewController.swift
//  CardLang
//
//  Created by Leonid on 05.11.2022.
//

import UIKit
import RSKPlaceholderTextView

class EditSetViewController: UIViewController {
    
    
    private let defaultsRepository = DefaultsRepository.shared
    
    @IBOutlet weak var setNameTextField: UITextField!
    private let setRepository =  SetRepository.shared
    
    @IBOutlet weak var definitionButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    
    private var set : WordSet?
    
    var delegate : PopUpControllerDelegate?
    
    
    private var name : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let set = set {
            setNameTextField.text = set.name
        }
        
        let shuffleMode = defaultsRepository.getShuffleMode()
        
        definitionButton.isSelected = shuffleMode == .showDefinitions ? true : false
        termButton.isSelected = shuffleMode == .showTerms ? true : false
        
        setNameTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let set = set, let name = name  {
            if(!name.isEmpty){
                setRepository.updateSetName(set: set, name: name){
                    self.delegate?.onDismissed()
                }
            }
        }
    }
    
    private func onDeleteOptionChosen(){
        if let set = set {
            setRepository.deleteWordSet(set: set)
            dismiss(animated: true)
        }
       
    }
    
    @IBAction func termButtonClicked(_ sender: UIButton) {
        definitionButton.isSelected = !definitionButton.isSelected
        
        defaultsRepository.setShuffleMode(mode: .showTerms)
        
    }
    
    @IBAction func deleteSetButtonClicked(_ sender: Any) {
        self.displayDialog(title: "Confirm", message: "Are you sure you want to delete this set?", firstOptionTitle: "Confirm", secondOptionTitle: "Cancel", firstCompletion: onDeleteOptionChosen, secondCompletion: {})
    }
    @IBAction func definitionButtonClicked(_ sender: UIButton) {
        termButton.isSelected = !termButton.isSelected
        
        defaultsRepository.setShuffleMode(mode: .showDefinitions)
    }
    func configure(_ set : WordSet?){
        self.set = set
    }
}


extension EditSetViewController : UITextFieldDelegate {
    
    func resizeTextView(_ textView : UITextView){
        let size = CGSize(width: textView.frame.width, height: .infinity)
        
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach {
            constraint in
            if(constraint.firstAttribute == .height){
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        name = textField.text
    }
}
