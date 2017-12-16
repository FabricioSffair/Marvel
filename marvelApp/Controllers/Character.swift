//
//  Character.swift
//  MarvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-14.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

struct Root : Decodable {
    let data : Results
}

struct Results : Decodable {
    let results : [Character]
}

class Character : Decodable {
    
    let id: Int
    let name: String
    let thumbnail : Thumbnail
    
    enum CharacterCodingKeys :  String, CodingKey {
        case id
        case name
        case thumbnail
    }
    
    required init(from decoder: Decoder) throws {
        let char = try decoder.container(keyedBy: CharacterCodingKeys.self)
        name = try char.decode(String.self, forKey: .name)
        id = try char.decode(Int.self, forKey: .id)
        thumbnail = try char.decode(Thumbnail.self, forKey: .thumbnail)
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.thumbnail == rhs.thumbnail
    }
    
}


