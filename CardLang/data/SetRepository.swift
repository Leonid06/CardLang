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
    
    private var realm : Realm?
    
    private var notificationToken =  NotificationToken()
    
    init(){
        Task {
            realm = try await realmService.getRealm()
        }
    }

    @MainActor
    func addWordSet(name : String){
        Task {
            do {
//                let realm = try await realmService.getRealm()
                
                if let realm = self.realm {
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
    func deleteWordSet(set : WordSet){
        Task {
            do {
//                let realm = try await realmService.getRealm()
                if let realm = self.realm {
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
//                let realm = try await realmService.getRealm()
                if let realm = self.realm {
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
    func getAllSets() async throws ->  [WordSet] {
        let task = Task { () -> [WordSet] in
            
            if let realm = self.realm {
//                do {
    //                let realm = try await realmService.getRealm()
                    return Array(realm.objects(WordSet.self)).reversed()
//                }catch {
//                    print(error)
//                }
            }
           
            return [WordSet]()
        }
        return try await task.result.get()
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
