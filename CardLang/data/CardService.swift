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
    
    func getTranslationForWord(_ word : String, completion: @escaping (Translation?, Error?) -> Void){
//        let url = CardService.HEAD_URL + "en/" + word.lowercased()
        let url = CardService.HEAD_URL + word.lowercased() + "?key=" + Constants.API_KEY
        performRequest(url: url, completion: completion)
//        print("request was performed")
    }
    
    func getAllTranslationForWord(_ word : String, completion: @escaping ([Translation]?, Error?) -> Void) {
        let url = CardService.HEAD_URL + word.lowercased() + "?key=" + Constants.API_KEY
        performRequest(url: url, completion: completion)
    }
    
    private func performRequest(url : String, completion : @escaping ([Translation]?, Error?) -> Void){
        if let url = URL(string: url){
            var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
            
//            request.addValue(Constants.APP_ID, forHTTPHeaderField: "app_id")
//            request.addValue(Constants.AUTH_KEY, forHTTPHeaderField: "app_key")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request ) { data, response, error in
                if error != nil {
                    completion(nil, error)
//                    print(error)
                    return
                } else {
//                    print(response)
//                    print(data)
                }
                
                if let safeData = data {
                    let translations = self.parseToMultipleTranslations(data: safeData)
//                    print(translation)
//                    print(safeData)
//                    print(translation)
                    completion(translations,nil)
                }
            }
            task.resume()
        }
    }
    
    private func performRequest(url : String, completion : @escaping (Translation?, Error?) -> Void){
        if let url = URL(string: url){
            var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
            
//            request.addValue(Constants.APP_ID, forHTTPHeaderField: "app_id")
//            request.addValue(Constants.AUTH_KEY, forHTTPHeaderField: "app_key")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request ) { data, response, error in
                if error != nil {
                    completion(nil, error)
//                    print(error)
                    return
                } else {
//                    print(response)
//                    print(data)
                }
                
                if let safeData = data {
                    let translation = self.parseToSingleTranslation(data: safeData)
//                    print(translation)
//                    print(safeData)
//                    print(translation)
                    completion(translation,nil)
                }
            }
            task.resume()
        }
    }
    
    private func parseToMultipleTranslations(data : Data?) -> [Translation]? {
        do {
            
//            let decodedData = try decoder.decode(WordData.self, from: data ?? Data())
            
            let decodedData =  try JSON(data: data ?? Data())
            
            var word = decodedData[0]["meta"]["id"].stringValue
            
            word.removeAll {
                !$0.isLetter
            }
            
            print(decodedData)
            
            var translations = [Translation]()
            
            let definitions = decodedData[0]["def"][0]["sseq"].arrayValue
            
            for definition in definitions {
                var translation = definition[0][0][1]["dt"][0][1].stringValue
                
                if(translation.count > 4){
                    let index = translation.index(translation.startIndex, offsetBy: 4)
                    
                    translation.removeSubrange(translation.startIndex ..< index)
                }
                
                translations.append(Translation(word: word, translation: translation))
            }
            
            return translations
        } catch {
            print(error)
            return nil
        }
    }
    
    private func parseToSingleTranslation(data: Data?) -> Translation? {
//        let decoder = JSONDecoder()
        do {
            
//            let decodedData = try decoder.decode(WordData.self, from: data ?? Data())
            
            let decodedData =  try JSON(data: data ?? Data())
            
            print(decodedData)
            
            var word = decodedData[0]["meta"]["id"].stringValue
            var translation = decodedData[0]["def"][0]["sseq"][0][0][1]["dt"][0][1].stringValue
            
            print(translation)
            
            word.removeAll {
                !$0.isLetter
            }
            
            if(translation.count > 4){
                let index = translation.index(translation.startIndex, offsetBy: 4)
                
                translation.removeSubrange(translation.startIndex ..< index)
            }
           
            
            return Translation(word: word, translation: translation)
        } catch {
            print(error)
            return nil
        }
    }
}

extension CardService {
//    private static let HEAD_URL = "https://od-api.oxforddictionaries.com:443/api/v2/entries/"
    private static let HEAD_URL = "https://www.dictionaryapi.com/api/v3/references/learners/json/"

}
