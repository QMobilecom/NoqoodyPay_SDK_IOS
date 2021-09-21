//
//  PaymentWebSceneInteractor.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

protocol PaymentWebSceneBusinessLogic: AnyObject {
    func loadPaymentURL()
    func checkForDomain(url: URL)
}

protocol PaymentWebSceneDataStore: AnyObject {
    var paymentLink: String? { get set }
    var config: ConfigModel? { get set }
}

class PaymentWebSceneInteractor: PaymentWebSceneBusinessLogic, PaymentWebSceneDataStore {

    // MARK: Stored Properties
    let presenter: PaymentWebScenePresentationLogic

    var paymentLink: String? = nil

    var config: ConfigModel? = nil

    var refrenceId: String? = nil

    // MARK: Initializers
    required init(presenter: PaymentWebScenePresentationLogic) {
        self.presenter = presenter
    }
}

extension PaymentWebSceneInteractor {

    func loadPaymentURL() {
        guard let url = paymentLink else {
            return
        }
        self.presenter.present(url: url)
    }

    func checkForDomain(url: URL) {
        guard let urlString = self.config?.callBackURL, let callBackURL = URL(string: urlString) else {
            self.presenter.present(refrence: "", error: "Invalid Call Back URL")
            return
        }

        if url.host == callBackURL.host {
            self.presenter.presentFinalPayment()
        }
    }
}
