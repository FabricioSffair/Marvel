//
//  Character.swift
//  MarvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-14.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  Modelo do Character, onde o JSON originalmente vem em uma estutura:
//  Root
//      -Results
//          -Character
//              -Thumbnail
//  Foi utilizado o Decodable nativo para o parsing.
//

import Foundation
import UIKit

struct Root : Decodable {
    let data : Results
}

struct Results : Decodable {
    let results : [Character]
}

class Character : Decodable {
    
    struct Participations : Decodable {
        let available : Int
    }
    
    let id : Int
    let thumbnail : Thumbnail
    let name : String
    let description : String
    let comics : Participations
    let events : Participations
    let series : Participations
    let stories : Participations
    
    
    enum CharacterCodingKeys :  String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case comics
        case events
        case series
        case stories
        
    }
    
    required init(from decoder: Decoder) throws {
        let char = try decoder.container(keyedBy: CharacterCodingKeys.self)
        name = try char.decode(String.self, forKey: .name)
        id = try char.decode(Int.self, forKey: .id)
        thumbnail = try char.decode(Thumbnail.self, forKey: .thumbnail)
        description = try char.decode(String.self, forKey: .description)
        comics = try char.decode(Participations.self, forKey: .comics)
        events = try char.decode(Participations.self, forKey: .events)
        series = try char.decode(Participations.self, forKey: .series)
        stories = try char.decode(Participations.self, forKey: .stories)
        
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.thumbnail == rhs.thumbnail
    }
    
}


