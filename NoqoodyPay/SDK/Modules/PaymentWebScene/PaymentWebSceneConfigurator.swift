//
//  PaymentWebSceneConfigurator.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

class PaymentWebSceneConfigurator {

    static func configure() -> PaymentWebViewController {
        let viewController = PaymentWebViewController()
        let presenter = PaymentWebScenePresenter(displayView: viewController)
        let interactor = PaymentWebSceneInteractor(presenter: presenter)
        let router = PaymentWebSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        return viewController
    }
}
