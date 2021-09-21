
//
//  NetworkManager.swift
//  Optio
//
//  Created by HE on 9/12/18.
//  Copyright © 2018 HE. All rights reserved.
//

import Foundation

enum NetworkResponseError: Error {
    case noData
    case unableToDecode
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

struct NetworkManager {
    
    static func sendRequest<T:EndPointType, P:Codable>(_ requestBuilder: T, completion: @escaping (_ statusCode: Int, _ response: Result<P>) -> ()) {
        
        let router = Router<T>()
        router.request(requestBuilder) { (data, response, error) in
            if let error = error {
                completion(-1, .failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                print("StatusCode: \(statusCode)")
                
                guard let responseData = data else {
                    completion(statusCode, .failure(NetworkResponseError.noData))
                    return
                }
                do {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    print(jsonData as Any)
                    let obj:P = try JSONDecoder().decode(P.self, from: responseData)
                    completion(statusCode, .success(obj))
                }catch let error {
                    completion(statusCode, .failure(error))
                }
            }
        }
    }
    
    static func sendRequest<T:EndPointType, P:Codable>(_ requestBuilder: T, completion: @escaping (_ response: Result<P>) -> ()) {
        
        let router = Router<T>()
        router.request(requestBuilder) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let response = response as? HTTPURLResponse {
                let statusCode = response.statusCode
                print("StatusCode: \(statusCode)")
                
                guard let responseData = data else {
                    completion(.failure(NetworkResponseError.noData))
                    return
                }
                do {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    print(jsonData as Any)
                    let obj:P = try JSONDecoder().decode(P.self, from: responseData)
                    completion(.success(obj))
                }catch let error {
                    completion(.failure(error))
                }
            }
        }
    }
}
















extension Encodable
{
    func toJson()->[String:Any]?
    {
        guard
            let encoded = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(with: encoded, options: .allowFragments) as? [String:Any]
            else { return nil }
        
        return dictionary
    }
}

extension Data
{
    func getObject<T:Decodable>()->T?
    {
        do
        {
            let parsedData  = try JSONDecoder().decode(T.self, from: self)
            return parsedData
        }
        catch let error
        {
            print(error)
        }
        return nil
    }
}
extension Sequence
{
    func getData()->Data?
    {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
    func getObject<T:Decodable>()->T?
    {
        guard
            let data = self.getData() else{ return nil }
        return data.getObject()
    }
}

