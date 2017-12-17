//
//  API.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-14.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
// url: String, andParams params: [String: Any]?=nil, withLimit limit: Int? = nil, andOffset offset: Int? = nil

import Foundation
import Alamofire
import UIKit

class API {
    
    static func GETCharacterList(offset: Int, limit: Int, completionHandler: @escaping ([Character]?, Error?) -> Void) {
        
        guard let urlToCall = createUrlWithParam(offset: offset, limit: limit, endPoint: EndPoints.characterList) else {
            print("Error: Cannot create URL")
            return
        }
        self.createRequest(url: urlToCall) { (data, error) in
            
            if let responseData = data {
                let decoder = JSONDecoder()
                do {
                    let todos = try decoder.decode(Root.self, from: responseData)
                    completionHandler(todos.data.results, nil)
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                    completionHandler(nil, error)
                }
            } else if let erro = error {
                completionHandler(nil, erro)
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    static func createUrlWithParam(offset: Int, limit: Int, endPoint: String) -> URL? {
        
        let timeStamp = Int(Date().timeIntervalSince1970 * 1000)
        let hash = "\(timeStamp)\(APISettings.privateKey)\(APISettings.publicKey)"
        
        return URL(string: APISettings.url + endPoint + "?offset=\(offset)&limit=\(limit)&apikey=\(APISettings.publicKey)&hash=\(hash.MD5)&ts=\(timeStamp)")
    }
    
    static private func createParamsForOffset(offset: Int?, andLimit limit: Int?) -> Alamofire.Parameters? {
        
        if offset != nil || limit != nil {
            var params = Alamofire.Parameters()
            if let offset = offset {
                params["offset"] = offset
            }
            if let limit = limit {
                params["limit"] = limit
            }
            return params
        }
        return nil
    }
    
    static func createRequest(url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(nil, error)
                return
            }
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(responseData, nil)
        }
        task.resume()
    }
    
}





