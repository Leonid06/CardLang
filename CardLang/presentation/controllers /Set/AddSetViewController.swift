//
//  AddSetViewController.swift
//  CardLang
//
//  Created by Leonid on 02.01.2023.
//

import UIKit

class AddSetViewController: UIViewController {
    
    private let setRepository = SetRepository.shared
    private let folderRepository = FolderRepository.shared
    
    
    private var folder : Folder?

    @IBOutlet weak var setDescriptionTextField: UnderlinedTextField!
    @IBOutlet weak var setNameTextField: UnderlinedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createSetButtonClicked(_ sender: Any) {
        if let name = setNameTextField.text {
            if(!name.isEmpty){
                if let folder = folder {
                    folderRepository.addSetToFolder(setName: name, folder: folder){
                        self.dismiss(animated: true)
                    }
                }else {
                    setRepository.addWordSet(name: name)
                }
            }
          
        }
        dismiss(animated: true)
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    func configure(_ folder : Folder){
        self.folder = folder
    }
}
