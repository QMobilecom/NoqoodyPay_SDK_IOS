//
//  PaymentWebViewController.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import WebKit

protocol PaymentWebViewControllerDelegate: AnyObject {
    func paymentWebDidFinishPayment(viewController: PaymentWebViewController)
    func paymentWeb(viewController: PaymentWebViewController, didFailedLoadingURL error: Error)
}

protocol PaymentWebSceneDisplayView: AnyObject {
    func displayURL(viewModel: PaymentWebScene.Payment.ViewModel)
    func displayError(viewModel: PaymentWebScene.Error.ViewModel)
    func displayFinished()
}

class PaymentWebViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!

    public weak var delegate: PaymentWebViewControllerDelegate? = nil

    var interactor: PaymentWebSceneBusinessLogic!
    var dataStore: PaymentWebSceneDataStore!
    var viewStore: PaymentWebSceneViewStore!
    var router: PaymentWebSceneRoutingLogic!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.interactor.loadPaymentURL()
    }
}

extension PaymentWebViewController: PaymentWebSceneDisplayView {
    func displayURL(viewModel: PaymentWebScene.Payment.ViewModel) {
        let urlRequest = URLRequest(url: viewModel.url)
        self.webView.load(urlRequest)
    }

    func displayError(viewModel: PaymentWebScene.Error.ViewModel) {
        self.delegate?.paymentWebDidFinishPayment(viewController: self)
    }

    func displayFinished() {
        self.delegate?.paymentWebDidFinishPayment(viewController: self)
    }
}

extension PaymentWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.delegate?.paymentWeb(viewController: self, didFailedLoadingURL: error)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        self.interactor.checkForDomain(url: url)
    }
}

