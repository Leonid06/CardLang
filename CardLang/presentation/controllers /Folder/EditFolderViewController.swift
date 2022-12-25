//
//  EditFolderViewController.swift
//  CardLang
//
//  Created by Leonid on 22.12.2022.
//

import UIKit

class EditFolderViewController: UIViewController {
    
    private let folderRepository = FolderRepository.shared
    private var folder: Folder?

    @IBOutlet weak var nameTextField: UnderlinedTextField!
    @IBOutlet weak var descriptionTextField: UnderlinedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func onFolderUpdated(){
        dismiss(animated: true)
    }
    @IBAction func deleteButtonClicked(_ sender: Any) {
        if let folder = folder {
            dismiss(animated: true)
            folderRepository.deleteFolder(folder: folder)
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if let folder = folder, let name = nameTextField.text {
            if let description = descriptionTextField.text {
                folderRepository.modifyFolder(folder, name: name , description: description){
                    self.onFolderUpdated()
                }
            }else {
                folderRepository.modifyFolder(folder, name: name , description: nil){
                    self.onFolderUpdated()
                }
            }
        }
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func updateUI(){
        if let folder = folder {
            nameTextField.text = folder.name
            descriptionTextField.text = folder.folderDescription
        }
    }
    
    func  configure(_ folder: Folder){
        self.folder = folder
    }
}


