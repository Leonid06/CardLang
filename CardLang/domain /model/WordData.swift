//
//  WordData.swift
//  CardLang
//
//  Created by Leonid on 30.08.2022.
//
//
//import Foundation
//
//
//struct WordData : Codable  {
//    let meta : Meta?
//    let def : Def?
//}
//
//
//struct Meta : Codable {
//    let id : String?
//}
//
//struct Def : Codable {
//    var sseq : [[[String]]]?
//}
//
//struct Sseq : Codable {
//    let dt: [[Dt]]?
//}
//
//struct Dt






//struct WordData : Codable {
//    let id : String?
//    let results : [Results]?
//
////    enum CodingKeys : String, CodingKey {
////        case id = "id", results = "results"
////    }
//}
//
//struct Results : Codable {
//    let lexicalEntries : [LexicalEntries]?
//
////    enum CodingKeys : String, CodingKey {
////        case lexicalEntries = "lexicalEntries"
////    }
//}
//
//struct LexicalEntries : Codable {
//    let entries : [Entries]?
//
////    enum CodingKeys : String, CodingKey {
////        case entries = "entries"
////    }
//}
//
//struct Entries  : Codable {
//    let senses : [Senses]?
//
////    enum CodingKeys : String, CodingKey {
////        case senses = "senses"
////    }
//}
//
//struct Senses  : Codable {
//
//    let definitions : [String]?
//
////    enum CodingKeys : String, CodingKey {
////        case definitions = "definitions"
////    }
//}
