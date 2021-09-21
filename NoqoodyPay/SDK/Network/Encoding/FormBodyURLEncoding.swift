//
//  FormBodyURLEncoding.swift
//  NooqodyPay
//
//  Created by HE on 26/07/2021.
//

import Foundation

public struct FormBodyURLEncoding: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {

        var parametersArray = [String]()

        for (key,value) in parameters {
            parametersArray.append("\(key)=\(value)")
        }

        let stringValue: String = parametersArray.joined(separator: "&")
        let data = stringValue.data(using: .utf8)

        urlRequest.httpBody = data

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
}
