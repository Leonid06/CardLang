//
//  Folder.swift
//  CardLang
//
//  Created by Leonid on 03.12.2022.
//

import Foundation
import RealmSwift

class Folder : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var owner_id : String
    @Persisted var sets : List<WordSet>
    @Persisted var name : String
    @Persisted var dateTimeCreated : Date?
    @Persisted var dateTimeLastVisited: Date? 
    @Persisted var folderDescription : String?
    @Persisted var tagName : String?
    
    convenience init(ownerId: String, name: String, folderDescription: String){
        self.init()
        self.owner_id = ownerId
        self.name = name
        self.folderDescription = folderDescription
    }
}
