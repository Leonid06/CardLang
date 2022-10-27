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
    
    private var realm : Realm?
    
    static let shared = RealmService()
    
    deinit {
        for token in notificationTokens {
            token.invalidate()
        }
    }
    
    func getRealm() -> Realm? {
        if let realm = self.realm {
            return realm
        }
        return nil 
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
        
        if let _ = self.realm {
            
        }else {
                do {
                    try await login()
                    try await self.realm = instantiateRealm()
                    
                    print("instantiated realm")
                    
                }catch {
                    print(error)
                }
            }
        
        
        let sets = realm?.objects(WordSet.self)
        
        let token = sets?.observe {
            changes in
            
            switch changes {
            case .initial:
                print("notified initial")
                block()
            case .update:
                print("notified")
                block()
            case .error(let error):
                print(error)
            }
        }
        if let token = token {
            notificationTokens.append(token)
        }
        
            
            
        
    }
    
    @MainActor
    func addObserverOnTranslations(block: @escaping  () -> Void) async throws {
        
        if let _ = self.realm {
            
        }else {
            do {
                try await login()
                try await self.realm = instantiateRealm()
                
            }catch {
                print(error)
            }
        }
        
        
        let sets = realm?.objects(Translation.self)
        
        let token = sets?.observe {
            changes in
            
            switch changes {
            case .initial:
                block()
                print("notified")
            case .update:
                block()
                print("notified")
            case .error(let error):
                print(error)
            }
        }
        if let token = token {
            notificationTokens.append(token)
        }
        
        
    }
    
    private func instantiateRealm() async throws -> Realm {
        if let user =  getCurrentUser() {
            let realm = try await openSyncedRealm(user: user)
            
            return realm
        }
        return try await Realm()
    }
    
    private func login() async throws {
        try await app.login(credentials: Credentials.anonymous)
    }
    
    @MainActor
    private func openSyncedRealm(user: User) async throws -> Realm {
        let config = user.flexibleSyncConfiguration()
        
        
        let realm = try! await Realm(configuration: config, downloadBeforeOpen: .never)
        
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
    }
}
