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
    
    
    convenience init(word : String, translation: String, ownerId: String){
        self.init()
        self.word = word
        self.translation = translation
        self.owner_id = ownerId
    }
}
