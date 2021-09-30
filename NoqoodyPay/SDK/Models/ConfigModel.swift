//
//  ConfigModel.swift
//  NooqodyPay
//
//  Created by HE on 19/07/2021.
//

import Foundation

public enum NooqodyEnviroment {
    case NooqodyEnviromentSandBox
    case NooqodyEnviromentProduction
}

public struct ConfigModel {
    let environment: NooqodyEnviroment
    let callBackURL: String
    let projectCode: String
    let clientSecret: String
    let token: String
    let amount: Double
    let customerEmail: String
    let customerMobile: String
    let customerName: String
    let description: String

    public init(environment: NooqodyEnviroment, callBackURL: String, projectCode: String, clientSecret: String, token: String, amount: Double, customerEmail: String, customerMobile: String, customerName: String, description: String) {
        self.environment = environment
        self.callBackURL = callBackURL
        self.projectCode = projectCode
        self.clientSecret = clientSecret
        self.token = token
        self.amount = amount
        self.customerEmail = customerEmail
        self.customerMobile = customerMobile
        self.customerName = customerName
        self.description = description
    }
}
