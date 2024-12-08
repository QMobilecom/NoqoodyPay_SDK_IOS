//
//  PaymentWebScenePresenter.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import Foundation

protocol PaymentWebScenePresentationLogic: AnyObject {
    func present(url: String)
    func present(refrence: String, error: String)
    func presentFinalPayment()
}

protocol PaymentWebSceneViewStore: AnyObject {

}

class PaymentWebScenePresenter: PaymentWebScenePresentationLogic, PaymentWebSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: PaymentWebSceneDisplayView?

    // MARK: Initializers
    required init(displayView: PaymentWebSceneDisplayView) {
        self.displayView = displayView
    }
}

extension PaymentWebScenePresenter {

    func present(url: String) {
        let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlEncoded!) else {
            return
        }
        let viewModel = PaymentWebScene.Payment.ViewModel(url: url)
        self.displayView?.displayURL(viewModel: viewModel)
    }

    func present(refrence: String, error: String) {
        let viewModel = PaymentWebScene.Error.ViewModel(refrence: refrence, message: error)
        self.displayView?.displayError(viewModel: viewModel)
    }

    func presentFinalPayment() {
        self.displayView?.displayFinished()
    }
}
