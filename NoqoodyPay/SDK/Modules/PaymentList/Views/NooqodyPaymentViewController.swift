//
//  PaymentListViewController.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

public protocol NooqodyPaymentDelegate: AnyObject {
    func paymentSuccess(controller: NooqodyPaymentViewController, paymentModel: PaymentStatusModel)
    func paymentFailed(controller: NooqodyPaymentViewController, refrence: String, message: String)
}

protocol NooqodyPaymentSceneDisplayView: AnyObject {
    func displayError(viewModel: NooqodyPaymentScene.PaymentFailure.ViewModel)
    func displayChannels(viewModel: NooqodyPaymentScene.Channels.ViewModel)
    func displayPaymentSuccess(paymentModel: PaymentStatusModel)
    func displayPaymentFailure(viewModel: NooqodyPaymentScene.PaymentFailure.ViewModel)
}

public class NooqodyPaymentViewController: UIViewController {

    @IBOutlet private weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var merchantNameLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    @IBOutlet private weak var finalAmountLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!

    public weak var delegate: NooqodyPaymentDelegate? = nil

    var interactor: NooqodyPaymentSceneBusinessLogic!
    var dataStore: NooqodyPaymentSceneDataStore!
    var viewStore: NooqodyPaymentSceneViewStore!
    var router: NooqodyPaymentSceneRoutingLogic!

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.interactor.getPaymentLinks()
    }

    @IBAction private func payNow(_ sender: UIButton) {
        guard let selectedChannel = self.dataStore.selecteChannel else {
            return
        }
        self.router.routeToWebPaymentView(channel: selectedChannel, configFile: self.dataStore.config!)
    }
}

extension NooqodyPaymentViewController: NooqodyPaymentSceneDisplayView {

    func displayError(viewModel: NooqodyPaymentScene.PaymentFailure.ViewModel) {
        DispatchQueue.main.async {
            self.delegate?.paymentFailed(controller: self, refrence: viewModel.refrence, message: viewModel.message)
        }
    }

    func displayChannels(viewModel: NooqodyPaymentScene.Channels.ViewModel) {
        DispatchQueue.main.async {
            self.activityIndecator.stopAnimating()
            self.merchantNameLabel.text = viewModel.merchantName
            self.totalAmountLabel.text = "Total Amount: " + viewModel.amount
            self.finalAmountLabel.text = "QAR " + viewModel.amount
            self.descLabel.text = viewModel.desc

            self.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scrollView.isHidden = false
                self.collectionViewHeightConstraint.constant = self.collectionView.contentSize.height
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }

    func displayPaymentSuccess(paymentModel: PaymentStatusModel) {
        DispatchQueue.main.async {
            self.delegate?.paymentSuccess(controller: self, paymentModel: paymentModel)
        }
    }

    func displayPaymentFailure(viewModel: NooqodyPaymentScene.PaymentFailure.ViewModel) {
        DispatchQueue.main.async {
            self.delegate?.paymentFailed(controller: self,refrence: viewModel.refrence, message: viewModel.message)
        }
    }
}

extension NooqodyPaymentViewController {
    func setupView() {
        self.scrollView.isHidden = true
        self.collectionView.register(UINib(nibName: PaymentChannelCell.cellIdentifier, bundle: Bundle(for: PaymentChannelCell.self)), forCellWithReuseIdentifier: PaymentChannelCell.cellIdentifier)
        self.scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension NooqodyPaymentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewStore.channelsViewModel?.channels.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentChannelCell.cellIdentifier, for: indexPath) as! PaymentChannelCell
        cell.updateCell(viewModel: (self.viewStore.channelsViewModel?.channels[indexPath.row])!)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets: CGFloat = 32
        let width: CGFloat = (collectionView.frame.width - insets) / 3
        let height: CGFloat = width * 0.95
        return CGSize(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.interactor.selectChannel(index: indexPath.row)
    }
}

extension NooqodyPaymentViewController: PaymentWebViewControllerDelegate {

    func paymentWebDidFinishPayment(viewController: PaymentWebViewController) {
        viewController.dismiss(animated: true, completion: nil)
        self.interactor.checkPaymentStatus()
    }

    func paymentWeb(viewController: PaymentWebViewController, didFailedLoadingURL error: Error) {
        viewController.dismiss(animated: true, completion: nil)
        let refrence = (self.dataStore.refrence)!
        DispatchQueue.main.async {
            self.delegate?.paymentFailed(controller: self, refrence: refrence, message: error.localizedDescription)
        }
    }
}
