//
//  File.swift
//  CardLang
//
//  Created by Leonid on 03.01.2023.
//

import Foundation
import RealmSwift

//@MainActor
//func getAllSets() async throws ->  Results<WordSet>? {
//    let task = Task { () -> Results<WordSet>? in
//
//        if let realm =  realmService.getRealm() {
//                return realm.objects(WordSet.self)
//        }
//
//        return nil
//    }
//    return try await task.result.get()
//}


class SearchRepository {
    private let realmService = RealmService.shared
    
    static let shared = SearchRepository()
    
    
    @MainActor
    func getAllSetsByQuery(query : String)  async throws -> Results<WordSet>? {
        let task = Task { ()-> Results<WordSet>? in 
            if let realm = realmService.getRealm() {
                print(query)
                let filteredSets = realm.objects(WordSet.self).where {
                    
                    $0.name.like("*" + query + "*", caseInsensitive: true)
                }.sorted(byKeyPath: "_id", ascending: false)
                
                return filteredSets
            }
            return nil 
        }
        let result = try await task.result.get()
        print("Results count: \(result?.count)")
        return result
    }
}
