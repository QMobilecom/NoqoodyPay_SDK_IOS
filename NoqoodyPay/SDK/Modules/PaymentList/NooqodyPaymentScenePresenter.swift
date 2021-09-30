//
//  NooqodyPaymentScenePresenter.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol NooqodyPaymentScenePresentationLogic: AnyObject {
    func present(refrence: String, error: String)
    func present(refrence: String, error: Error)
    func presentChanels(channels: PaymentChannelModel, selected channel: PaymentChannel?)
    func presentPaymentSuccess(refrence: String, payment: PaymentStatusModel)
    func presentPaymentFailure(refrence: String, error: Error)
}

protocol NooqodyPaymentSceneViewStore: AnyObject {
    var channelsViewModel: NooqodyPaymentScene.Channels.ViewModel? { get set }
}

class NooqodyPaymentScenePresenter: NooqodyPaymentScenePresentationLogic, NooqodyPaymentSceneViewStore {

    // MARK: Stored Properties
    weak var displayView: NooqodyPaymentSceneDisplayView?

    var channelsViewModel: NooqodyPaymentScene.Channels.ViewModel?

    // MARK: Initializers
    required init(displayView: NooqodyPaymentSceneDisplayView) {
        self.displayView = displayView
    }
}

extension NooqodyPaymentScenePresenter {

    func present(refrence: String, error: String) {
        let viewModel = NooqodyPaymentScene.PaymentFailure.ViewModel(refrence: refrence,
                                                                  message: error)
        self.displayView?.displayError(viewModel: viewModel)
    }

    func present(refrence: String, error: Error) {
        let viewModel = NooqodyPaymentScene.PaymentFailure.ViewModel(refrence: refrence,
                                                                  message: error.localizedDescription)
        self.displayView?.displayError(viewModel: viewModel)
    }

    func presentChanels(channels: PaymentChannelModel, selected channel: PaymentChannel?) {

        var channelViewModel = [NooqodyPaymentScene.Channels.Channel]()

        channels.paymentChannels?.forEach {
            let imageURLEncoded = $0.imageLocation?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let viewModel = NooqodyPaymentScene.Channels.Channel(name: $0.channelName ?? "",
                                                              imageURL: imageURLEncoded ?? "",
                                                              paymentURL: $0.paymentURL ?? "",
                                                              isSelected: $0.id == channel?.id)
            channelViewModel.append(viewModel)
        }

        let amount = String(format: "%.02f", channels.transactionDetail?.amount ?? 0)
        self.channelsViewModel = NooqodyPaymentScene.Channels.ViewModel(channels: channelViewModel,
                                                                     desc: channels.transactionDetail?.transactionDescription ?? "",
                                                                     merchantName: channels.transactionDetail?.merchantName ?? "",
                                                                     amount: amount)
        self.displayView?.displayChannels(viewModel: self.channelsViewModel!)
    }

    func presentPaymentSuccess(refrence: String, payment: PaymentStatusModel) {
        switch payment.transactionStatus {
        case .success:
            self.displayView?.displayPaymentSuccess(paymentModel: payment)
        case .error:
            let viewModel = NooqodyPaymentScene.PaymentFailure.ViewModel(refrence: refrence,
                                                                      message: payment.transactionMessage ?? "Something Wrong Happen!")
            self.displayView?.displayPaymentFailure(viewModel: viewModel)
        case .none:
            break
        }
    }

    func presentPaymentFailure(refrence: String, error: Error) {
        let viewModel = NooqodyPaymentScene.PaymentFailure.ViewModel(refrence: refrence,
                                                                 message: error.localizedDescription)
        self.displayView?.displayPaymentFailure(viewModel: viewModel)
    }
}
