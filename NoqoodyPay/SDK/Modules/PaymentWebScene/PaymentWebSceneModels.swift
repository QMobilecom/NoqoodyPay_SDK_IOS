//
//  PaymentWebSceneModels.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

enum PaymentWebScene {
    enum Payment { }
    enum Error { }
}

extension PaymentWebScene.Payment {
    struct ViewModel {
        let url: URL
    }
}

extension PaymentWebScene.Error {
    struct ViewModel {
        let refrence: String
        let message: String
    }
}
