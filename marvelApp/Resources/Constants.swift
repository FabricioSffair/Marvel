//
//  Constants.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-14.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import Foundation

struct APISettings {
    
    static let url = "https://gateway.marvel.com:443/v1/public"
    static let privateKey = "bdb9b923970eeebcb53c256926f18e0f184ed24f"
    static let publicKey  = "432563d92445e36a798291cd3178b184"
}

struct EndPoints {
    static let characterList = "/characters"
}

struct CoreDataSettings {
    static let Entity = "Characters"
    static let ModelName = "Data"
}



typealias CharactersCompletionBlock = (_ characters: [[String: Any]]?, _ error: Error?) -> Void
typealias SuccessCompletionBlock = (_ success: Bool, _ error: Error?) -> Void
