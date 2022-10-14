//
//  Set.swift
//  CardLang
//
//  Created by Leonid on 04.09.2022.
//

import Foundation
import RealmSwift


class WordSet : Object {
    
    @Persisted var name : String
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var owner_id : String 
    @Persisted var translations : List<Translation> 
    
    convenience init(name : String, ownerId : String){
        self.init()
        self.name = name
        self.owner_id = ownerId
    }
}
