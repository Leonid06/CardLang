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
    
    private let soundService = SoundService.shared
    
    var delegate : PopUpControllerDelegate?
    
    
    private var term : String?
    
    private var meaning : String?
    
    private var isDeleted  = false
    
    
    private var translation : Translation?
    
    private var set : WordSet?
    
  
    @IBOutlet weak var playSoundButton: UIButton!
    @IBOutlet weak var termTextView: UITextView!
    @IBOutlet weak var meaningTextView: RSKPlaceholderTextView!
    @IBOutlet weak var wordTypeLabel: UILabel!
    
    func configure(_ translation: Translation, _ set: WordSet) {
        self.translation = translation
        self.set = set
     }

    @IBAction func playSoundButtonClicked(_ sender: UIButton) {
        if let translation = translation {
            print(translation.soundPath)
            if let soundPath = translation.soundPath  {
                soundService.playSound(soundPath: soundPath)
            }
        }
    }
    @IBAction func trashButtonClicked(_ sender: UIButton) {
        if let translation = translation, let set = set {
            updateTerm()
            setRepository.deleteTranslationFromSet(set: set, translation: translation){
                self.delegate?.onDismissed()
            }
            
            isDeleted = true 
        }
        
        dismiss(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSoundButton.isHidden = true
        
        if let translation = translation {
            termTextView.text = translation.word
            meaningTextView.text = translation.translation
            
            
            if let type = translation.type  {
                wordTypeLabel.text = translation.type
                adjustFontColor(type: type)
            }
            
            if translation.soundPath != nil {
                playSoundButton.isHidden = false
            }
        }
        
        termTextView.delegate = self
        meaningTextView.delegate = self
        
        resizeTextView(termTextView)
        resizeTextView(meaningTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(!isDeleted){
            updateTerm()
        }
    }
    
    private func updateTerm(){
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
    
    private func adjustFontColor(type : String){
        switch type {
        case "adverb":
            wordTypeLabel.textColor = UIColor.systemPurple
        case "adjective":
            wordTypeLabel.textColor = UIColor.systemBlue
        case "verb":
            wordTypeLabel.textColor = UIColor.systemPink
        default:
            wordTypeLabel.textColor = UIColor.systemGreen
        }
    }
}

extension TermViewController : UITextViewDelegate {
    
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
        resizeTextView(textView)
        if(textView.isEqual(termTextView)){
            term = textView.text
        }else {
            meaning = textView.text
        }
    }
}



