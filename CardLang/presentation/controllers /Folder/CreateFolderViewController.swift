//
//  CreateFolderViewController.swift
//  CardLang
//
//  Created by Leonid on 16.12.2022.
//

import UIKit
import RSKPlaceholderTextView

class CreateFolderViewController: UIViewController {
    
    
    private let folderRepository = FolderRepository.shared
    
   
    @IBOutlet weak var folderNameTextField: UnderlinedTextField!
    @IBOutlet weak var folderDescriptionTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addFolderButtonClicked(_ sender: UIButton) {
        if let name = folderNameTextField.text {
            if(!name.isEmpty){
                folderRepository.addFolder(name: name, description: folderDescriptionTextField.text ?? "")
            }
          
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}




