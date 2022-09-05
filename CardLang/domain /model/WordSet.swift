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
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var translations : List<Translation> 
    
    convenience init(name : String){
        self.init()
        self.name = name
    }
}
