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
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getToken, .getPaymentLinks:
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
