//
//  EditSetViewController.swift
//  CardLang
//
//  Created by Leonid on 05.11.2022.
//

import UIKit
import RSKPlaceholderTextView

class EditSetViewController: UIViewController {
    
    @IBOutlet weak var setNameTextField: UITextField!
    private let setRepository =  SetRepository.shared
    
    private var set : WordSet?
    
    var delegate : PopUpControllerDelegate?
    
    
    private var name : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let set = set {
            setNameTextField.text = set.name
        }
        
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
