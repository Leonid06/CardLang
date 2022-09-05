//
//  SetRepository.swift
//  CardLang
//
//  Created by Leonid on 04.09.2022.
//

import Foundation
import RealmSwift

class SetRepository {
    
    static let shared = SetRepository()
    
    private let realm = try! Realm()
    
    func addWordSet(name : String){
        do {
            let set = WordSet(name: name)
            try realm.write {
//                realm.add(set, update: Realm.UpdatePolicy.modified)
                realm.add(set)
            }
        }catch {
            print(error)
        }
    }
    
    func addTranslationToSet(set : WordSet, translation : Translation){
        do  {
            try realm.write {
                set.translations.append(translation)
            }
        }catch {
            print(error)
        }
    }
    
    func getAllSets() ->  [WordSet] {
        print("sets returned:")
        print(Array(realm.objects(WordSet.self)))
        return Array(realm.objects(WordSet.self)).reversed()
    }
}
