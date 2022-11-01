//
//  TermViewController.swift
//  CardLang
//
//  Created by Leonid on 01.11.2022.
//

import UIKit
import RSKPlaceholderTextView

class TermViewController: UIViewController {
    
    private let setRepository = SetRepository.shared
    
    
    private var term : String?
    
    private var meaning : String?
    
    
    private var translation : Translation?
    
    private var set : WordSet?
    
  
    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var meaningTextView: RSKPlaceholderTextView!
    
    func configure(_ translation:Translation, _ set: WordSet) {
        self.translation = translation
        self.set = set
     }

    @IBAction func trashButtonClicked(_ sender: UIButton) {
        if let translation = translation, let set = set {
            setRepository.deleteTranslationFromSet(set: set, translation: translation, completion: {})
        }
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let translation = translation {
            termTextView.text = translation.word
            meaningTextView.text = translation.translation
        }
        
        termTextView.delegate = self
        meaningTextView.delegate = self
        
        textViewDidChange(termTextView)
        textViewDidChange(meaningTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let translation = translation {
            if let term = term {
                if(!term.isEmpty){
                    setRepository.updateTermTitle(translation, title: term)
                }
                
            }
            if let meaning = meaning {
                if(!meaning.isEmpty){
                    setRepository.updateTermMeaning(translation, meaning: meaning)
                }
                
            }
        }
       
    }
}

extension TermViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach {
            constraint in
            if(constraint.firstAttribute == .height){
                constraint.constant = estimatedSize.height
            }
        }
        if(textView.isEqual(termTextView)){
            term = textView.text
        }else {
            meaning = textView.text
        }
    }
}
