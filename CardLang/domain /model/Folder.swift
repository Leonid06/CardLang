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
    
    convenience init(ownerId: String){
        self.init()
        self.owner_id = ownerId
    }
}
