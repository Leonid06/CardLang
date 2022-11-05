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
    
    private let realmService = RealmService.shared
    
    private var notificationToken =  NotificationToken()


    @MainActor
    func addWordSet(name : String){
        Task {
            do {
//                let realm = try await realmService.getRealm()
                
                if let realm = realmService.getRealm() {
                    let user = realmService.getCurrentUser()
                    let set = WordSet(name: name, ownerId: user?.id ?? "")

                    try realm.write {
                        realm.add(set, update: Realm.UpdatePolicy.modified)
                    }
                }
                
                
            }catch {
                print(error)
            }
            
        }
    }
    
    @MainActor
    func updateTermTitle(_ translation: Translation, title: String){
        Task {
            do {
                
                if let realm = realmService.getRealm() {
                    try realm.write {
                        translation.word = title
                    }
                }
                
                
            }catch {
                print(error)
            }
            
        }
    }
    
    @MainActor
    func updateTermMeaning(_ translation: Translation, meaning: String){
        Task {
            do {
                
                if let realm = realmService.getRealm() {
                    try realm.write {
                        translation.translation = meaning
                    }
                }
                
                
            }catch {
                print(error)
            }
            
        }
    }
    
    @MainActor
    func deleteWordSet(set : WordSet){
        Task {
            do {
                if let realm = realmService.getRealm() {
                    try realm.write {
                        realm.delete(set)
                    }
                }
                
            } catch{
                print(error)
            }
        }
        
    }
    
    @MainActor
    func addTranslationToSet(set : WordSet, translation : Translation, completion: @escaping () -> Void){
        Task {
            do  {
                if let realm = realmService.getRealm() {
                    try realm.write {
                        set.translations.append(translation)
                    }
                    completion()
                }
            }catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func addTranslationToSet(set : WordSet, term : String, meaning : String, completion: @escaping () -> Void){
        Task {
            do  {
                if let realm = realmService.getRealm() {
                    let user = realmService.getCurrentUser()
                    let translation = Translation(word: term, translation: meaning, ownerId: user?.id ?? "")
                    try realm.write {
                        set.translations.append(translation)
                    }
                    completion()
                }
            }catch {
                print(error)
            }
        }
    }
    @MainActor
    func deleteTranslationFromSet(set : WordSet, translation : Translation, completion: @escaping () -> Void){
        Task {
            do  {
                if let realm = realmService.getRealm() {
                    try realm.write {
                        realm.delete(translation)
                    }
                    completion()
                }
            }catch {
                print(error)
            }
        }
        
    }
    
    @MainActor
    func getAllSets() async throws ->  Results<WordSet>? {
        let task = Task { () -> Results<WordSet>? in
            
            if let realm =  realmService.getRealm() {
                    return realm.objects(WordSet.self)
            }
           
            return nil
        }
        return try await task.result.get()
    }
    
    @MainActor
    func updateSetName(set : WordSet, name : String, completion: @escaping () -> Void) {
        Task {
            do  {
                if let realm = realmService.getRealm() {
                    try realm.write {
                        set.name = name
                    }
                    completion()
                }
            }catch {
                print(error)
            }
        }
    }
    
    func subscribeToUpdatesOnSets(block : @escaping () -> Void){
        Task {
            do {
                try await realmService.addObserverOnSets {
                    block()
                }
            }catch {
                print(error)
            }
            
        }
    }
    
    func subscribeToUpdatesOnTranslations(block : @escaping () -> Void){
        Task {
            do {
                try await realmService.addObserverOnTranslations {
                    block()
                }
            }catch {
                print(error)
            }
            
        }
    }
}
