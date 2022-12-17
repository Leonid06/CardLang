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
    
    
  
    @IBOutlet weak var folderDescriptionTextView: RSKPlaceholderTextView!
    @IBOutlet weak var folderNameTextView: RSKPlaceholderTextView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addFolderButtonClicked(_ sender: UIButton) {
        if let name = folderNameTextView.text {
            folderRepository.addFolder(name: name, description: folderDescriptionTextView.text ?? "")
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension CreateFolderViewController : UITextViewDelegate {
    
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
    func textViewDidChange(_ textView: UITextView) {
        resizeTextView(folderDescriptionTextView)
        resizeTextView(folderNameTextView)
    }
}

