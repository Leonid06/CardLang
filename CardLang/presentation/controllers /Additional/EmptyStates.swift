//
//  EmptyStates.swift
//  CardLang
//
//  Created by Leonid on 16.02.2023.
//

import Foundation
import EmptyStateKit



enum EmptyState: CustomState {
    case noSets
    case noTranslations
    case noFolders
    case noResults
    
    
    var title : String?  {
        switch self {
        case .noSets : return "No sets created yet"
        case .noTranslations : return "No terms added to this set yet"
        case .noFolders : return "No folders created yet"
        case .noResults: return "No translations found for this term"
        }
    }
    
    var description: String? {
        switch self {
        case .noSets : return "You don't have any sets created here"
        case .noTranslations: return "You don't have any terms created in this set"
        case .noFolders: return "You don't have any folders created"
        case .noResults: return "Try another one"
        }
    }
}
