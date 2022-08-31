//
//  WordData.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//

import Foundation


struct WordData : Codable {
    let id : String
    let results : [Results]
}

struct Results : Codable {
    let lexicalEntries : [LexicalEntries]
}

struct LexicalEntries : Codable {
    let entries : [Entries]
}

struct Entries  : Codable {
    let senses : [Senses]
}

struct Senses  : Codable {
    let definitions : [String]
}
