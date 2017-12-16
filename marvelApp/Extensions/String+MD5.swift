//
//  String+MD5.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-15.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//

import Foundation

extension String{
    var MD5:String {
        get{
            let messageData = self.data(using:.utf8)!
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            
            _ = digestData.withUnsafeMutableBytes { digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
                }
            }
            
            return digestData.map { String(format: "%02hhx", $0) }.joined()
        }
    }
}
