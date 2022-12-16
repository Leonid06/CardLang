//
//  Constants .swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation


struct Constants {
    static let API_KEY = Bundle.main.infoDictionary?["WORD_API_KEY"] as? String
    
    struct RealmSubscriptions {
        static let FoldersSubscription = "folders_subscription"
        static let SetsSubscription = "sets_subscription"
        static let TranslationsSubscription = "translations_subscription"
    }
}
