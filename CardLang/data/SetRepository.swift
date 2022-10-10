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
    
    private var notificationToken =  NotificationToken()
    
    private let app = App(id: "cardlang-gyuck")
    
    
    deinit {
        notificationToken.invalidate()
    }
    
    func instansiateRealm(block: @escaping () -> Void) {
        Task.init {
            let user =  try! await self.login()
            try await openSyncedRealm(user: user, block: block)
        }
    }
    
    private func login() async throws -> User {
        // Authenticate with the instance of the app that points
        // to your backend. Here, we're using anonymous login.
        let user = try await app.login(credentials: Credentials.anonymous)
        print("Successfully logged in user: \(user)")
        return user
    }
    
    @MainActor
    private func openSyncedRealm(user: User, block: @escaping ()-> Void) async throws {
        let config = user.flexibleSyncConfiguration()
        // Pass object types to the Flexible Sync configuration
        // as a temporary workaround for not being able to add a
        // complete schema for a Flexible Sync app.
//        config.objectTypes = [Translation.self, WordSet.self]
        
        
        
        realm = try! await Realm(configuration: config, downloadBeforeOpen: .never)
        
        let subscriptions = realm.subscriptions
        
        try await subscriptions.update {
                if let _ = subscriptions.first(named : "all-sets") {
                    return
                }else {
                    subscriptions.append(QuerySubscription<WordSet>(name: "all-sets"))
                    subscriptions.append(QuerySubscription<Translation>(name: "all-tranlations"))
                }
        }
        let sets = realm.objects(WordSet.self)

        self.notificationToken = sets.observe { changes in
            switch changes {
            case .initial :
                print("called at initial state")
                block()
            case .update :
                block()
            case .error(let error):
                print(error)
            }
        }
    }
    
    func subscribeToUpdates(completion:  @escaping () -> Void){
        let sets = realm.objects(WordSet.self)
        
        _ = sets.observe { changes in
            completion()
        }
    }
    
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
