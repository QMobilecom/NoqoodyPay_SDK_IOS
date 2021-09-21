//
//  NooqodyPaymentSceneWorkers.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

class NooqodyPaymentSceneWorkers {

    func getToken(userName: String,
                  password: String,
                  success: @escaping (TokenModel) -> Void,
                  failure: @escaping (Error) -> Void) {
        let router = ApiRequest.getToken(username: userName, password: password)
        NetworkManager.sendRequest(router) { (statusCode, result: Result<TokenModel>) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error)
            }
        }
    }

    func getPaymentLink(token: String,
                        code: String,
                        refrence: String,
                        description: String,
                        email: String,
                        phone: String,
                        name: String,
                        amount: Double,
                        secureHash: String,
                        success: @escaping (PaymentLinksModel) -> Void,
                        failure: @escaping (Error) -> Void) {

        let router = ApiRequest.getPaymentLinks(token: token,
                                                code: code,
                                                refrence: refrence,
                                                description: description,
                                                email: email,
                                                phone: phone,
                                                name: name,
                                                amount: amount,
                                                secureHash: secureHash)
        NetworkManager.sendRequest(router) { (statusCode, result: Result<PaymentLinksModel>) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error)
            }
        }
    }

    func getPaymentChannels(sessionId: String, uuid: String,
                            success: @escaping (PaymentChannelModel) -> Void,
                            failure: @escaping (Error) -> Void) {

        let router = ApiRequest.getPaymentChannels(sessionId: sessionId, uuid: uuid)
        NetworkManager.sendRequest(router) { (statusCode, result: Result<PaymentChannelModel>) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error)
            }
        }
    }

    func getPaymentStatus(token: String, refrence: String,
                            success: @escaping (PaymentStatusModel) -> Void,
                            failure: @escaping (Error) -> Void) {

        let router = ApiRequest.checkPaymentStatus(token: token, refrence: refrence)
        NetworkManager.sendRequest(router) { (statusCode, result: Result<PaymentStatusModel>) in
            switch result {
            case .success(let response):
                success(response)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
