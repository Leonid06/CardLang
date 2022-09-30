//
//  CardServiceTest.swift
//  CardLangTests
//
//  Created by Leonid on 30.09.2022.
//

import XCTest
@testable import CardLang

final class CardServiceTest: XCTestCase {
    
    func testPerformRequest(){
        let head = "https://www.dictionaryapi.com/api/v3/references/learners/json/"
        let word = "apple"
        let url = head + word.lowercased() + "?key=" + Constants.API_KEY!
        
        for _ in 1...50 {
            let request = URLRequest(url: URL(string: url)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request ) { data, response, error in
                XCTAssertEqual(true, error == nil)
                
            }
        }
    }
    func testGetAllTranslationForWord(){
        let cardService = CardService.shared
        
        let word = "tip"
        
        for _ in 1...20 {
            cardService.getAllTranslationForWord(word){ translations, error in
                XCTAssertEqual(true, error == nil)
                XCTAssertEqual(true, translations!.count > 0)
            }
        }
    }
}
