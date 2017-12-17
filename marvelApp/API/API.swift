//
//  API.swift
//  marvelApp
//
//  Created by Fabrício Sperotto Sffair on 2017-12-14.
//  Copyright © 2017 Fabrício Sperotto Sffair. All rights reserved.
//
//  API Com método para buscar a lista de personagens e a criação de requisição.
//  Aqui foi feito uma API simples e a busca da lista pois não havia necessidade
//  de muita complexidade para o teste, podendo ter feito alguma estrutura
//  mais escalável caso fosse necessário.
//

import Foundation
import UIKit


class API {
    
    // Método onde busca a lista de personagens e faz o Parsing para retornar em um bloco
    // a lista já em sua classe.
    static func GETCharacterList(offset: Int, limit: Int, completionHandler: @escaping ([Character]?, Error?) -> Void) {
        
        guard let urlToCall = createUrlWithParam(offset: offset, limit: limit, endPoint: EndPoints.characterList) else {
            print("Error: Cannot create URL")
            return
        }
        self.createRequest(url: urlToCall) { (data, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let responseData = data {
                let decoder = JSONDecoder()
                do {
                    let rootJson = try decoder.decode(Root.self, from: responseData)
                    completionHandler(rootJson.data.results, nil)
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





