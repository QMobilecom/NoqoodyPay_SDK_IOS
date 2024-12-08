//
//  ApiRequest.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//

import Foundation

enum ApiRequest {
    case getToken(username: String, password: String)
    case getPaymentLinks(token: String, code: String, refrence: String, description: String, email: String, phone: String, name: String, amount: Double, secureHash: String)
    case getPaymentChannels(sessionId: String, uuid: String)
    case checkPaymentStatus(token: String, refrence: String)
    case createApplePaySession(sessionId: String, uuid: String)
    case proccesApplePayPayment(appleSessionID: String, device: String,
                                version: String, signature: String,
                                data: String,ephemeralPublicKey:  String,
                                publicKeyHash: String, transactionId: String)
}

extension ApiRequest: EndPointType {

    var parameters: Parameters? {
        switch self {
        case .getToken(let username, let password):
            return ["username": username,
                    "password": password,
                    "grant_type": "password"]
        case .getPaymentLinks(_, let projectCode, let refrence, let description, let email, let phone, let name, let amount, let secureHash):
            return ["ProjectCode": projectCode,
                    "reference": refrence,
                    "description": description,
                    "CustomerEmail": email,
                    "CustomerMobile": phone,
                    "CustomerName": name,
                    "amount": amount,
                    "SecureHash": secureHash]
        case .getPaymentChannels(let sessionId, let uuid):
            return ["session_id": sessionId,
                    "uuid": uuid]
        case .checkPaymentStatus(_, let refrence):
            return ["ReferenceNo": refrence]
        case .createApplePaySession(let sessionId, let uuid):
            return ["SessionID": sessionId,
                    "UUID": uuid]
        case .proccesApplePayPayment(let appleSessionID,let device, let version, let signature, let data,let ephemeralPublicKey,let publicKeyHash, let transactionId):
            
            let header: [String: Any] =  ["ephemeralPublicKey": ephemeralPublicKey,
                                          "publicKeyHash":publicKeyHash,
                                          "transactionId": transactionId
            ]
            let paymentToken:  [String: Any] = ["version":version,
                                                "signature":signature,
                                                "header": header,
                                                "data": data
            ]
            let paramters : [String: Any] = [ "AppleSessionID": appleSessionID,
                                              "device": device,
                                              "PaymentToken": paymentToken,
                                             
            ]
            return paramters
        
        }
    }

    var path: ServerPaths {
        switch self {
        case .getToken:
            return .getToken
        case .getPaymentLinks:
            return .getPaymentLinks
        case .getPaymentChannels:
            return .getPaymentChannels
        case .checkPaymentStatus:
            return .checkPaymentStatus
        case .createApplePaySession:
            return .createApplePaySession
        case .proccesApplePayPayment:
            return .proccesApplePayPayment
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getToken, .getPaymentLinks, .createApplePaySession, .proccesApplePayPayment:
            return .post
        case .getPaymentChannels, .checkPaymentStatus:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getToken:
            return .requestParametersAndHeaders(bodyParameters: parameters, bodyEncoding: .formBodyUrlencoded, urlParameters: nil, additionHeaders: headers)
        case .getPaymentLinks:
            return .requestParametersAndHeaders(bodyParameters: parameters, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
        case .getPaymentChannels, .checkPaymentStatus:
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters, additionHeaders: headers)
        case .createApplePaySession:
            return .requestParameters(bodyParameters: parameters, bodyEncoding: .jsonEncoding, urlParameters: nil)
        case .proccesApplePayPayment:
            return .requestParameters(bodyParameters: parameters, bodyEncoding: .jsonEncoding, urlParameters: nil)
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getPaymentLinks(let token, _, _, _, _, _, _, _, _):
            return ["Authorization": "bearer \(token)"]
        case .checkPaymentStatus(let token, _):
            return ["Authorization": "bearer \(token)"]
        default:
            return nil
        }
    }

    var pathArgs: [String]? {
        return nil
    }
}
