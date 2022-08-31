//
//  CardService.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation


class CardService {
    
    static let shared = CardService()
    
    func getTranslationForWord(_ word : String, completion: @escaping (Translation?, Error?) -> Void){
        let url = CardService.HEAD_URL + "en/" + word.lowercased()
        performRequest(url: url, completion: completion)
        print("request was performed")
    }
    private func performRequest(url : String, completion : @escaping (Translation?, Error?) -> Void){
        if let url = URL(string: url){
            var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
            
            request.addValue(Constants.APP_ID, forHTTPHeaderField: "app_id")
            request.addValue(Constants.AUTH_KEY, forHTTPHeaderField: "app_key")
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request ) { data, response, error in
                if error != nil {
//                    completion(nil, error)
//                    print(error)
                    return
                } else {
//                    print(response)
//                    print(data)
                }
                
                if let safeData = data {
                    let translation = self.parseJSON(data: safeData)
//                    print(translation)
//                    print(safeData)
                    completion(translation,nil)
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(data: Data?) -> Translation? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WordData.self, from: data ?? Data())
            
            let word = decodedData.id
            let translation = decodedData.results[0].lexicalEntries[0].entries[0].senses[0].definitions[0]
        
            return Translation(word: word, translation: translation)
        } catch {
            print(error)
            return nil
        }
    }
}

extension CardService {
    private static let HEAD_URL = "https://od-api.oxforddictionaries.com:443/api/v2/entries/"
}
