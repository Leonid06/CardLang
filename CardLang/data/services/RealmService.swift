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
    
    func getCurrentUserEmail() -> String? {
        return app.currentUser?.profile.email
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
                Task {
                    try await self.realm = self.instantiateRealm()
                }
            }
        }
//        try await loginAnonymousUser()
//        completion(true)
        
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
        
        
        if let folders = realm?.objects(Folder.self){
            let token = folders.observe {
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
            notificationTokens.append(token)
        }else {
            self.realm = try await instantiateRealm()
            try await addObserverOnFolders(block: block)
        }
    }
    
    
    
    @MainActor
    func addObserverOnSets(block: @escaping  () -> Void) async throws {
        
        if let sets  = realm?.objects(WordSet.self){
            let token = sets.observe {
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
            notificationTokens.append(token)
        }else {
            self.realm = try await instantiateRealm()
            try await addObserverOnSets(block: block)
        }
    }
    
    @MainActor
    func addObserverOnTranslations(block: @escaping  () -> Void) async throws {
        
        if let translations  = realm?.objects(Translation.self){
            let token = translations.observe {
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
            notificationTokens.append(token)
        }else {
            self.realm = try await instantiateRealm()
            try await addObserverOnTranslations(block: block)
        }
        
    }
    
    private func instantiateRealm() async throws -> Realm {
        
        if let user =  getCurrentUser() {
            print(user.id)
            
            let realm = try await openSyncedRealm(user: user)
            
            return realm
        }
        return try await Realm()
    }
    
    func registerUser(email: String, password: String) async -> Bool  {
        let client = app.emailPasswordAuth
        
        do {
            try await client.registerUser(email: email, password: password)
//            try await loginAnonymousUser()
//            if let anonymousUser = app.currentUser {
//                await linkAnonymousUser(anonymousUser, with: Credentials.emailPassword(email: email, password: password))
//                print(app.currentUser)
//            }
//
            print("Successfully registered user!")
            return true
        }catch {
            print(error)
        }
        
        return false
      
    }
    
    private func linkAnonymousUser(_ user: User, with credentials : Credentials) async {
        user.linkUser(credentials: credentials){
            result in
            switch result {
            case .failure(let error):
                print("Failed to link user: \(error)")
            case .success(let user):
                print("Successfully linked user: \(user)")
            }
        }
        
    }
    
    private func loginAnonymousUser() async throws {
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
