//
//  ConfigModel.swift
//  NooqodyPay
//
//  Created by HE on 19/07/2021.
//

import Foundation

enum NooqodyEnviroment {
    case NooqodyEnviromentSandBox
    case NooqodyEnviromentProduction
}

struct ConfigModel {
    let environment: NooqodyEnviroment
    let callBackURL: String
    let code: String
    let token: String
    let amount: Double
    let customerEmail: String
    let customerMobile: String
    let customerName: String
    let description: String
}
