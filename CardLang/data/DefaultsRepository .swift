

import Foundation


enum ShuffleMode {
    case showTerms
    case showDefinitions
}

class DefaultsRepository {
    
    
    static let shared = DefaultsRepository()
    
    
    private let userDefaults = UserDefaults.standard
    
    
    func setShuffleMode(mode : ShuffleMode){
        switch mode {
        case .showTerms:
            userDefaults.set(true, forKey: UserDefaultsKeys.shuffleMode)
        case .showDefinitions:
            userDefaults.set(false, forKey: UserDefaultsKeys.shuffleMode)
        }
    }
    
    
    func getShuffleMode() -> ShuffleMode {
        let showTerm =  userDefaults.bool(forKey: UserDefaultsKeys.shuffleMode)
        
        return showTerm ? .showTerms : .showDefinitions
    }
}
