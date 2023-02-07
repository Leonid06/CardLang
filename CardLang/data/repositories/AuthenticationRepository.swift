//
//  AuthenticationRepository.swift
//  CardLang
//
//  Created by Leonid on 29.01.2023.
//

import Foundation
import RealmSwift


class AuthenticationRepository {
    static let shared = AuthenticationRepository()
    private let realmService = RealmService.shared
    
    
  
    func registerUser(email: String, password: String, completion : @escaping (Bool) -> Void) async {
        let task = Task { () -> Bool in
            return await realmService.registerUser(email: email, password: password)
        }
        do {
            let result = try await task.result.get()
            completion(result)
        }catch {
            completion(false)
        }
    }
    
    func logOut(completion: @escaping (Bool) -> Void) async {
        let task = Task { () -> Bool in
            return await realmService.logOutUser()
        }
        do {
            let result = try await task.result.get()
            completion(result)
        }catch {
            completion(false)
        }
    }
    
    func getCurrentUserEmail() -> String? {
        if let email = realmService.getCurrentUserEmail() {
            return email
        }
        return nil 
    }
    

    func logInUser(email: String, password: String, completion: @escaping (Bool) -> Void) async {
        Task {
            try await realmService.logInUser(email: email, password: password){
                loggedIn in completion(loggedIn)
            }
        }
    
    }
    private func checkIfToReinstantiateRealm(onSceneInitialization: Bool) async {
        let userIsLoggedIn = realmService.currentUserIsLoggedIn()
        if (userIsLoggedIn && onSceneInitialization) {
            await realmService.instantiateRealm()
        }
    }
    
    @MainActor
    func checkIfUserIsLoggedIn(onSceneInitialization: Bool, completion: @escaping @MainActor (Bool)-> Void) async  {
        let task = Task { () -> Bool in
            await checkIfToReinstantiateRealm(onSceneInitialization: onSceneInitialization)
            return realmService.currentUserIsLoggedIn()
        }
        do {
            let result =  try await task.result.get()
            completion(result)
        }catch{
            print(error)
        }
        completion(false)
    }
}
