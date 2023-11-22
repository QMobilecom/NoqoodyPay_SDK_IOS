//
//  NooqodyPaymentSceneRouter.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol NooqodyPaymentSceneRoutingLogic: AnyObject {
    typealias Controller = NooqodyPaymentSceneDisplayView & NooqodyPaymentViewController

    func routeToWebPaymentView(channel: PaymentChannel, configFile: ConfigModel)
}

class NooqodyPaymentSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension NooqodyPaymentSceneRouter: NooqodyPaymentSceneRoutingLogic {

    func routeToWebPaymentView(channel: PaymentChannel, configFile: ConfigModel) {
        let viewController = PaymentWebSceneConfigurator.configure()
        viewController.dataStore.paymentLink = channel.paymentURL
        viewController.dataStore.config = configFile
        viewController.delegate = self.viewController
        viewController.modalPresentationStyle = .fullScreen
        self.viewController?.present(viewController, animated: true, completion: nil)
    }
}
