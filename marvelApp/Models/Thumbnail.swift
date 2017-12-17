//
//  Thumbnail.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-16.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import Foundation

struct Thumbnail : Decodable {
    
    let path: String
    let ext: String
    
    init(from decoder: Decoder) throws {
        let thumb = try decoder.container(keyedBy: ThumbnailCodingKeys.self)
        path = try thumb.decode(String.self, forKey: .path)
        ext = try thumb.decode(String.self, forKey: .ext)
    }
    
    enum ThumbnailCodingKeys : String, CodingKey {
        case path
        case ext = "extension"
    }
    
    static func == (lhs: Thumbnail, rhs: Thumbnail) -> Bool {
        return lhs.path == rhs.path && lhs.ext == rhs.ext
    }
}
