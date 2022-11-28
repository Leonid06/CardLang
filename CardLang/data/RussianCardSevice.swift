

import Foundation


class RussianCardService {
    
    static let shared = RussianCardService()
    
    private func performRequest(url : String, completion : @escaping ([Translation]?, Error?) -> Void){
        
    }
    
    private func parseToMultipleTranslations(data: Data?){
        
    }
    
    func getAllTranslationsForWord(_ word : String, completion: @escaping (Translation?, Error?) -> Void){
        
    }
}

extension CardService {
    private static let HEAD_URL = ""
}
