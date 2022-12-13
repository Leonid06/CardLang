//
//  FolderRepository.swift
//  CardLang
//
//  Created by Leonid on 03.12.2022.
//

import Foundation
import RealmSwift


class FolderRepository {
    static let shared = FolderRepository()
    
    private let realmService = RealmService.shared
    
    @MainActor
    func getAllFolders() async throws ->  Results<Folder>? {
        let task = Task { () -> Results<Folder>? in
            
            if let realm = realmService.getRealm() {
                    return realm.objects(Folder.self)
            }
           
            return nil
        }
        return try await task.result.get()
    }
    
    @MainActor
    func addSetToFolder(set : WordSet, folder: Folder, completion: @escaping () -> Void){
        Task {
            do  {
                if let realm = realmService.getRealm() {
                    let user = realmService.getCurrentUser()
                    
                    try realm.write {
                        folder.sets.append(set)
                    }
                    completion()
                }
            }catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func deleteSetFromFolder(set : WordSet, folder: Folder, completion: @escaping () -> Void){
        Task {
            do  {
                if let realm = realmService.getRealm() {
                    try realm.write {
                        if let index = folder.sets.firstIndex(where: { $0._id == set._id}) {
                            folder.sets.remove(at: index)
                        }
                    }
                    completion()
                }
            }catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func deleteFolder(folder : Folder){
        Task {
            do {
                if let realm = realmService.getRealm() {
                    try realm.write {
                        realm.delete(folder)
                    }
                }
                
            } catch{
                print(error)
            }
        }
    }
    
    @MainActor
    func subscribeOnUpdatesOnFolders(block : @escaping () -> Void){
        Task {
            do {
                try await realmService.addObserverOnFolders {
                    block()
                }
            }catch{
                print(error)
            }
        }
    }
    
    @MainActor
    func addFolder(name : String, description: String){
        Task {
            do {
                
                if let realm = realmService.getRealm() {
                    let user = realmService.getCurrentUser()
                    let folder = Folder(ownerId: user?.id ?? "", name: name, folderDescription: description)

                    try realm.write {
                        realm.add(folder, update: Realm.UpdatePolicy.modified)
                    }
                }
                
                
            }catch {
                print(error)
            }
            
        }
    }
    
}
