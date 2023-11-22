//
//  BaseURLConfig.swift
//  NooqodyPay
//
//  Created by HE on 03/08/2021.
//

import Foundation

class BaseURLConfig {

    static let shared = BaseURLConfig()
    private var BaseURL: String = Constants.BASEURL.stagingEnvironment.rawValue

    func setCongif(environment: NooqodyEnviroment) {
        switch environment {
        case .NooqodyEnviromentSandBox:
            self.BaseURL = Constants.BASEURL.stagingEnvironment.rawValue
        case .NooqodyEnviromentProduction:
            self.BaseURL = Constants.BASEURL.productionEnvironment.rawValue
        }
    }

    func getBaseURL() -> String {
        return self.BaseURL
    }
}
