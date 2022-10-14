//
//  RealmService.swift
//  CardLang
//
//  Created by Leonid on 14.10.2022.
//

import Foundation
import RealmSwift


class RealmService {

    
    private var notificationTokens = [NotificationToken]()
    
    private let app = App(id: "cardlang-gyuck")
    
    static let shared = RealmService()
    
    private init(){}
    
    deinit {
        for token in notificationTokens {
            token.invalidate()
        }
    }
    
    func getCurrentUser() -> User? {
        if let user = app.currentUser {
            return user
        } else {
            return nil
        }
    }
    
    @MainActor
    func addObserverOnSets(block: @escaping  () -> Void) async throws {
        let user =  try! await self.login()
        let realm = try await openSyncedRealm(user: user)
        
        let sets = realm.objects(WordSet.self)
        
        let token = sets.observe {
            changes in
            
            switch changes {
            case .initial:
                block()
            case .update:
                block()
            case .error(let error):
                print(error)
            }
        }
        
        notificationTokens.append(token)
    }
    
    @MainActor
    func addObserverOnTranslations(block: @escaping  () -> Void) async throws {
        let user =  try! await self.login()
        let realm = try await openSyncedRealm(user: user)
        
        let sets = realm.objects(Translation.self)
        
        let token = sets.observe {
            changes in
            
            switch changes {
            case .initial:
                block()
            case .update:
                block()
            case .error(let error):
                print(error)
            }
        }
        
        notificationTokens.append(token)
    }
    
    func getRealm() async throws -> Realm {
        let user =  try! await self.login()
        let realm = try await openSyncedRealm(user: user)
        
        return realm 
    }
    
    private func login() async throws -> User {
        // Authenticate with the instance of the app that points
        // to your backend. Here, we're using anonymous login.
        let user = try await app.login(credentials: Credentials.anonymous)
        print("Successfully logged in user: \(user)")
        return user
    }
    
    @MainActor
    private func openSyncedRealm(user: User) async throws -> Realm {
        let config = user.flexibleSyncConfiguration()
        // Pass object types to the Flexible Sync configuration
        // as a temporary workaround for not being able to add a
        // complete schema for a Flexible Sync app.
//        config.objectTypes = [Translation.self, WordSet.self]
        
        
        
        let realm = try! await Realm(configuration: config, downloadBeforeOpen: .once)
        
        let subscriptions = realm.subscriptions
        
        try await subscriptions.update {
                if let _ = subscriptions.first(named : "all-sets") {
                    return
                }else {
                    subscriptions.append(QuerySubscription<WordSet>(name: "all-sets"))
                    subscriptions.append(QuerySubscription<Translation>(name: "all-tranlations"))
                }
        }
        
        return realm
//        let sets = realm.objects(WordSet.self)

//        self.notificationToken = sets.observe { changes in
//            switch changes {
//            case .initial :
//                print("called at initial state")
//                block()
//            case .update :
//                block()
//            case .error(let error):
//                print(error)
//            }
//        }
    }
}
