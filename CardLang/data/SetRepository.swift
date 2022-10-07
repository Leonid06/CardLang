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
    
    private var realm = try! Realm()
    
    private let app = App(id: "cardlang-gyuck")
    
    
//    init(){
//        DispatchQueue.main.async {
//            let user = try! self.login()
//        }
//        
//    }
//    
//    private func login() async throws -> User {
//        // Authenticate with the instance of the app that points
//        // to your backend. Here, we're using anonymous login.
//        let user = try await app.login(credentials: Credentials.anonymous)
//        print("Successfully logged in user: \(user)")
//        return user
//    }
//    
//    private func openSyncedRealm(user: User) async {
//        do {
//            var config = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
//                subs.append(
//                    QuerySubscription<Todo> {
//                        $0.ownerId == user.id
//                    })
//            })
//            // Pass object types to the Flexible Sync configuration
//            // as a temporary workaround for not being able to add a
//            // complete schema for a Flexible Sync app.
//            config.objectTypes = [Todo.self]
//            let realm = try await Realm(configuration: config, downloadBeforeOpen: .always)
//            
//        } catch {
//            print("Error opening realm: \(error.localizedDescription)")
//        }
//    }
    
    func addWordSet(name : String){
        do {
            let set = WordSet(name: name)
            try realm.write {
                realm.add(set, update: Realm.UpdatePolicy.modified)
            }
        }catch {
            print(error)
        }
    }
    
    
    func deleteWordSet(set : WordSet){
        do {
            try realm.write {
                realm.delete(set)
            }
        } catch{
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
        return Array(realm.objects(WordSet.self)).reversed()
    }
}
