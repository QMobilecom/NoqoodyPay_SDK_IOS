//
//  NooqodyPaymentSceneModels.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

enum NooqodyPaymentScene {
    enum Channels { }
    enum PaymentSuccess { }
    enum PaymentFailure { }
}

extension NooqodyPaymentScene.Channels {
    struct Channel {
        let name: String
        let imageURL: String
        let paymentURL: String
        let isSelected: Bool
    }

    struct ViewModel {
        let channels: [Channel]
        let desc: String
        let merchantName: String
        let amount: String
    }
}

extension NooqodyPaymentScene.PaymentSuccess {
    struct ViewModel {
        let refrence: String
        let transactionId: String
    }
}

extension NooqodyPaymentScene.PaymentFailure {
    struct ViewModel {
        let refrence: String
        let message: String
    }
}
