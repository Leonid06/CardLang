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
    
    func logOutUser() async -> Bool {
        do {
            try await app.currentUser?.logOut()
            return true 
        }catch {
            print(error)
        }
        return false
    }
    
    
    
    func logInUser(email: String, password: String, completion: @escaping (Bool) -> Void) async throws {
        app.login(credentials: Credentials.emailPassword(email: email, password: password)){ result in
            switch result {
            case .failure(let error):
                print(error)
                completion(false)
                
            case .success(let user):
                print("Successfully logged in by email as \(user)")
                completion(true)
            }
        }
    }
    
    
    func currentUserIsLoggedIn() -> Bool {
        return app.currentUser?.isLoggedIn ?? false 
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
    func addObserverOnFolders(block: @escaping  () -> Void) async throws {
        
        if let _ = self.realm {
            
        }else {
                do {
//                    try await login()
                    try await self.realm = instantiateRealm()
                    
                    print("instantiated realm")
                    
                }catch {
                    print(error)
                }
            }
        
        
        let folders = realm?.objects(Folder.self)
        
        let token = folders?.observe {
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
    func addObserverOnSets(block: @escaping  () -> Void) async throws {
        
        if let _ = self.realm {
            
        }else {
                do {
//                    try await login()
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
//                try await login()
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
    
    func registerUser(email: String, password: String) async -> Bool  {
        let client = app.emailPasswordAuth
        
        do {
            try await client.registerUser(email: email, password: password)
            try await login()
            if let anonymousUser = app.currentUser {
                linkAnonymousUser(anonymousUser, with: Credentials.emailPassword(email: email, password: password))
                try await anonymousUser.logOut()
                print(app.currentUser)
            }
            
            print("Successfully registered user!")
            return true
        }catch {
            print(error)
        }
        
        return false
      
    }
    
    private func linkAnonymousUser(_ user: User, with credentials : Credentials){
        user.linkUser(credentials: credentials){
            result in
            switch result {
            case .failure(let error):
                print("Failed to link user: \(error.localizedDescription)")
            case .success(let user):
                print("Successfully linked user: \(user)")
            }
        }
    }
    
    private func login() async throws {
        try await app.login(credentials: Credentials.anonymous)
    }
    
    @MainActor
    private func openSyncedRealm(user: User) async throws -> Realm {
        let config = user.flexibleSyncConfiguration()
        
        
        let realm = try! await Realm(configuration: config)
        
        print(realm)
        
        let subscriptions = realm.subscriptions
        
        if(subscriptions.count < 3){
            try await subscriptions.update {
                subscriptions.append(QuerySubscription<Folder>(name: Constants.RealmSubscriptions.FoldersSubscription))
                subscriptions.append(QuerySubscription<WordSet>(name: Constants.RealmSubscriptions.SetsSubscription))
                subscriptions.append(QuerySubscription<Translation>(name: Constants.RealmSubscriptions.TranslationsSubscription))
            }
        }
        
        

        
        
        return realm
    }
}
