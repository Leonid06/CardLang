//
//  CardService.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation
import SwiftyJSON


class CardService {
    
    static let shared = CardService()
    
    private let realmService  = RealmService.shared
    
    private let soundService = SoundService.shared
    
    func getAllTranslationForWord(_ word : String, completion: @escaping ([Translation]?, Error?) -> Void) {
        let url = CardService.HEAD_URL + word.lowercased() + "?key=" + Constants.API_KEY!
        performRequest(url: url, completion: completion)
    }
    
    private func performRequest(url : String, completion : @escaping ([Translation]?, Error?) -> Void){
        if let url = URL(string: url){
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request ) { data, response, error in
                if error != nil {
                    completion(nil, error)
                    print(error)
                    return
                }
                
                if let safeData = data {
                    let translations = self.parseToMultipleTranslations(data: safeData)
                    completion(translations,nil)
                }
            }
            task.resume()
        }
    }
    
    private func parseTranslationString(_ string: String) -> String {
        var translationString = string
        while let firstIndex = translationString.firstIndex(of: "{"){
            if let secondIndex = translationString.firstIndex(of: "}"){
                translationString.removeSubrange(firstIndex ... secondIndex)
            }
        }
        
        return translationString.trimmingCharacters(in: .whitespaces)
    }
    
    private func parseSoundUrl(meaning : JSON) -> String? {
        
        var soundURL = meaning["vrs"][0]["prs"][0]["sound"]["audio"].stringValue
        
        if(soundURL.isEmpty){
            soundURL = meaning["hwi"]["prs"][0]["sound"]["audio"].stringValue
        }
        
        return soundURL
    }
    
    private func parseToMultipleTranslations(data : Data?) -> [Translation]? {
        do {
            
            let decodedData =  try JSON(data: data ?? Data())
            
            var word = decodedData[0]["meta"]["id"].stringValue
            
            word.removeAll {
                !$0.isLetter
            }
            
            var translations = [Translation]()
            
            let meanings = decodedData.arrayValue
            
            
            var soundURL : String = ""
            
            var soundFound = false
            
            for meaning in meanings {
                if(!soundFound){
                    if let url = parseSoundUrl(meaning: meaning) {
                        soundURL = url
                        soundFound = true
                    }
                }
                
                let type = meaning["fl"].stringValue
                let definitions = meaning["def"][0]["sseq"].arrayValue
                
                for definition in definitions {
                    var translation : String
                    
                    let terms = definition.arrayValue
                    
                    for term in terms {
                        translation = term[1]["dt"][0][1].stringValue
                        if translation.isEmpty {
                            translation = term[0][1]["dt"][0][1][0][0][1].stringValue
                        }
                        
                        
                        translation = parseTranslationString(translation)
                        
                        if(!translation.isEmpty){
                            let user = realmService.getCurrentUser()
                            
                            if(!soundURL.isEmpty){
                                translations.append(Translation(word: word, translation: translation, ownerId: user?.id ?? "", type: type, soundPath: soundURL))
                            }else {
                                translations.append(Translation(word: word, translation: translation, ownerId: user?.id ?? "", type: type, soundPath: nil))
                            }
                            
                        }
                    }
                }
            }
            soundService.saveSound(soundPath: soundURL)
            
            return translations
        } catch {
            print(error)
            return nil
        }
    }
}

extension CardService {
    private static let HEAD_URL = "https://www.dictionaryapi.com/api/v3/references/learners/json/"
}
