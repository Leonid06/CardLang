//
//  CardRepository.swift
//  CardLang
//
//  Created by Leonid on 31.08.2022.
//

import Foundation


class CardRepository {
    static let shared = CardRepository()
    
    private let realmService = RealmService.shared
    
    private let group = DispatchGroup()
    
    private let cardService = CardService()
    
    private var translations = [Translation]()
    
    
    func  fetchMultipleTranslationsForWord(_ word : String, completion: @escaping ([Translation]) -> Void) {
        group.enter()
        
        let components = word.components(separatedBy: .whitespacesAndNewlines)
        
        print(components)
        
        if let trimmedWord = components.first(where: {
            !$0.isEmpty
        }){
            cardService.getAllTranslationForWord(trimmedWord, completion: onMultipleTranslationsFetched)
        }
    
        
        group.notify(queue: .main){
            print("group did notify main thread")
            completion(self.translations)
        }
        
        
    }
    
    private func onMultipleTranslationsFetched(translations : [Translation]? , error: Error?){
        if let error = error {
            print(error)
        }
        if let translations = translations {
            self.translations = translations
        }
        
        group.leave()
    }
    
    private func onTranslationFetched(translation : Translation?, error : Error?){
            if let error = error {
                group.leave()
                print("word left group with error")
                print(error)
            }
            
            if let translation = translation {
                self.translations.append(translation)
                print("word left group")
                print("translation count : \(translations.count)")
                group.leave()
            }
    }
}
