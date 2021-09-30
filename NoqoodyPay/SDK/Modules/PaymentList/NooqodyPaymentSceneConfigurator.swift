//
//  NooqodyPaymentSceneConfigurator.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

public class NooqodyPaymentSceneConfigurator {

    public static func configure(config: ConfigModel) -> NooqodyPaymentViewController {
        let viewController = NooqodyPaymentViewController.instance()
        let presenter = NooqodyPaymentScenePresenter(displayView: viewController)
        let interactor = NooqodyPaymentSceneInteractor(presenter: presenter)
        let router = NooqodyPaymentSceneRouter(controller: viewController)
        viewController.interactor = interactor
        viewController.dataStore = interactor
        viewController.router = router
        viewController.viewStore = presenter
        viewController.dataStore.config = config
        BaseURLConfig.shared.setCongif(environment: config.environment)
        return viewController
    }
}
