//
//  PaymentWebSceneRouter.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol PaymentWebSceneRoutingLogic: AnyObject {
    typealias Controller = PaymentWebSceneDisplayView & PaymentWebViewController
}

class PaymentWebSceneRouter {

    // MARK: Stored Properties
    var viewController: Controller?

    // MARK: Initializers
    required init(controller: Controller?) {
        self.viewController = controller
    }
}

extension PaymentWebSceneRouter: PaymentWebSceneRoutingLogic {

}
