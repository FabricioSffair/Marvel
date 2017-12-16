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
    
    static func GET() -> DataRequest {
        
        let url = APISettings.url + EndPoints.characterList
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        
        var parameters = createParamsForOffset(offset: 0, andLimit: 20) ?? Alamofire.Parameters()
        
        parameters.updateValue("name", forKey: "orderBy")
//        parameters.updateValue(timeStamp, forKey: "ts")
        parameters.updateValue(APISettings.publicKey, forKey: "apikey")
//        parameters.updateValue(hash.MD5, forKey: "hash")
        
        return Alamofire.request(url, method: .get, parameters: parameters)
            .response {
                response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
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
    
    static func createRequest(completionHandler: @escaping ([Character]?, Error?) -> Void) {
        let timeStamp = Int(Date().timeIntervalSince1970 * 1000)
        let hash = "\(timeStamp)\(APISettings.privateKey)\(APISettings.publicKey)"
        let urlString = APISettings.url + "/characters" + "?apikey=\(APISettings.publicKey)&hash=\(hash.MD5)&ts=\(timeStamp)"
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
//            completionHandler(nil, error)
            return
        }
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
            
            let decoder = JSONDecoder()
            do {
                let todos = try decoder.decode(Root.self, from: responseData)
                completionHandler(todos.data.results, nil)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
    
    private func getHashAndTimeStamp() -> [String: Any] {
        let timeStamp = Int(Date().timeIntervalSince1970 * 1000)
        let hash = "\(timeStamp)\(APISettings.privateKey)\(APISettings.publicKey)"
        return [
            "hash":hash,
            "ts": timeStamp
            ]
    }
    
}





