//
//  Translation .swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import IceCream
import Foundation
import RealmSwift


class Translation : Object {
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var word : String
    @Persisted var translation : String
    
    
    convenience init(word : String, translation: String){
        self.init()
        self.word = word
        self.translation = translation
    }
}

extension Translation : CKRecordConvertible, CKRecordRecoverable {
    var isDeleted: Bool {
        return false 
    }
}

