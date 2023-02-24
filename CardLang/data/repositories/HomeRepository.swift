//
//  HomeRepository.swift
//  CardLang
//
//  Created by Leonid on 23.02.2023.
//

import Foundation
import RealmSwift


class HomeRepository {
    static let shared = HomeRepository()
    private let realmService = RealmService.shared
    
    @MainActor
    func getRecentlyVisitedWordSets(completion: @escaping (Results<WordSet>?) -> Void) {
        if let realm = realmService.getRealm() {
            var recentWordSets = realm.objects(WordSet.self).sorted(byKeyPath: "dateTimeLastVisited")
            if recentWordSets.isEmpty {
                recentWordSets = realm.objects(WordSet.self)
            }
            completion(recentWordSets)
        }
        completion(nil)
    }
    
    @MainActor
    func getRecentlyVisitedFolders(completion: @escaping (Results<Folder>?) -> Void)  {
        if let realm = realmService.getRealm() {
            var recentFolders = realm.objects(Folder.self).sorted(byKeyPath: "dateTimeLastVisited")
            if recentFolders.isEmpty {
                recentFolders = realm.objects(Folder.self)
            }
            completion(recentFolders)
        }
        
        completion(nil)
    }
}
