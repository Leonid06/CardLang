//
//  Translation .swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation
import RealmSwift


class Translation : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var owner_id : String 
    @Persisted var word : String
    @Persisted var translation : String
    @Persisted var type : String?
    @Persisted var soundPath: String?
    @Persisted(originProperty: "translations") var currentSet : LinkingObjects<WordSet>
    
    
    convenience init(word : String, translation: String, ownerId: String, type: String?, soundPath: String?){
        self.init()
        self.word = word
        self.translation = translation
        self.owner_id = ownerId
        self.type = type
        self.soundPath = soundPath
    }
}
