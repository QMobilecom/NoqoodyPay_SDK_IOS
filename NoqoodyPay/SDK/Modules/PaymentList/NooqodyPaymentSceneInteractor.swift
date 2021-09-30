//
//  NooqodyPaymentSceneInteractor.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

enum InternalErrors: Error {
    case InvalidUserNameAndPassword
}

protocol NooqodyPaymentSceneBusinessLogic: AnyObject {
    func getPaymentLinks()
    func selectChannel(index: Int)
    func checkPaymentStatus()
}

protocol NooqodyPaymentSceneDataStore: AnyObject {
    var config: ConfigModel? { get set }
    var paymentChannelModel: PaymentChannelModel? { get set }
    var selecteChannel: PaymentChannel? { get set }
    var refrence: String! { get set }
}

class NooqodyPaymentSceneInteractor: NooqodyPaymentSceneBusinessLogic, NooqodyPaymentSceneDataStore {

    // MARK: Stored Properties
    let presenter: NooqodyPaymentScenePresentationLogic

    var config: ConfigModel? = nil

    var paymentChannelModel: PaymentChannelModel? = nil

    var selecteChannel: PaymentChannel? = nil

    var refrence: String!

    let worker = NooqodyPaymentSceneWorkers()

    // MARK: Initializers
    required init(presenter: NooqodyPaymentScenePresentationLogic) {
        self.presenter = presenter
        self.refrence = self.randomString()
    }
}

extension NooqodyPaymentSceneInteractor {

    func getPaymentLinks() {

        guard let token = self.config?.token, let code = self.config?.projectCode, let clientSecret = self.config?.clientSecret, let desc = self.config?.description, let email = self.config?.customerEmail, let phone = self.config?.customerMobile, let name = self.config?.customerName, let amount = self.config?.amount else {
            return
        }

        let patamsString = email+name+phone+desc+code+refrence
        let secureHash = patamsString.hmac(algorithm: .SHA256, key: clientSecret)

        self.worker.getPaymentLink(token: token,
                                   code: code,
                                   refrence: self.refrence,
                                   description: desc,
                                   email: email,
                                   phone: phone,
                                   name: name,
                                   amount: amount,
                                   secureHash: secureHash)
        { payment in
            if payment.success == false {
                self.presenter.present(refrence: self.refrence, error: payment.message ?? "Something Wrong Happen")
            } else {
                self.getPaymentChannels(paymentLink: payment)
            }
        } failure: { error in
            self.presenter.present(refrence: self.refrence, error: error)
        }
    }

    func selectChannel(index: Int) {
        let channel = self.paymentChannelModel?.paymentChannels![index]
        guard self.selecteChannel?.id != channel?.id else {
            return
        }
        self.selecteChannel = self.paymentChannelModel?.paymentChannels![index]
        self.presenter.presentChanels(channels: self.paymentChannelModel!, selected: self.selecteChannel)
    }

    func checkPaymentStatus() {
        guard let token = self.config?.token else {
            return
        }
        self.worker.getPaymentStatus(token: token, refrence: refrence) { payment in
            self.presenter.presentPaymentSuccess(refrence: self.refrence, payment: payment)
        } failure: { error in
            self.presenter.presentPaymentFailure(refrence: self.refrence, error: error)
        }
    }
}

private extension NooqodyPaymentSceneInteractor {

    func getPaymentChannels(paymentLink: PaymentLinksModel) {
        guard let sessionId = paymentLink.sessionID, let uuid = paymentLink.uuid, let refrence = paymentLink.reference else {
            return
        }
        self.worker.getPaymentChannels(sessionId: sessionId,
                                       uuid: uuid)
        { paymentChannels in
            self.paymentChannelModel = paymentChannels
            self.presenter.presentChanels(channels: paymentChannels, selected: self.selecteChannel)
        } failure: { error in
            self.presenter.present(refrence: refrence, error: error)
        }
    }
}

private extension NooqodyPaymentSceneInteractor {
    func randomString() -> String {
      let letters = "0123456789"
      return String((0..<20).map{ _ in letters.randomElement()! })
    }
}
