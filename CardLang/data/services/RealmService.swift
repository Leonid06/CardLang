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
    
    private let app = App(id: Constants.APP_ID!)
    
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
            Task {
                switch result {
                case .failure(let error):
                    print(error)
                    completion(false)

                case .success(_):
                    try await self.realm = self._instantiateRealm {
                        completion(true)
                    }
                }
            }
           
        }
    }
    
    
    func currentUserIsLoggedIn() -> Bool {
        return (app.currentUser?.isLoggedIn ?? false && !currentUserIsAnonymous())
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
                    block()
                case .update:
                    block()
                case .error(let error):
                    print(error)
                }
            }
            notificationTokens.append(token)
        }
    }
    
    
    
    @MainActor
    func addObserverOnSets(block: @escaping  () -> Void) async throws {
        
        if let sets  = realm?.objects(WordSet.self){
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
    }
    
    @MainActor
    func addObserverOnTranslations(block: @escaping  () -> Void) async throws {
        
        if let translations  = realm?.objects(Translation.self){
            let token = translations.observe {
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
    }
    func instantiateRealm() async {
        do{
            self.realm = try await _instantiateRealm {}
        }catch {
            print(error)
        }
        
    }
    
    private func _instantiateRealm(completion: @escaping () -> Void) async throws -> Realm {
        
        if let user =  getCurrentUser() {
            
            let realm = try await openSyncedRealm(user: user)
            completion()
            return realm
        }
        return try await Realm()
    }
    
    private func currentUserIsAnonymous() -> Bool {
        let currentUser = app.currentUser
        return currentUser?.identities.allSatisfy {
            identity in
            let result = identity.providerType == "anon-user"
            print(result)
            return result
        } ?? false
    }
    
    func registerUser(email: String, password: String) async -> Bool  {
        let client = app.emailPasswordAuth
        
        do {
            try await client.registerUser(email: email, password: password)
            return true
        }catch {
            print(error)
        }
        
        return false
      
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
