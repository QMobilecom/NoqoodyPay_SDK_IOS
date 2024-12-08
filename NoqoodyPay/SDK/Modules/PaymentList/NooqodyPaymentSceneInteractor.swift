//
//  NooqodyPaymentSceneInteractor.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import PassKit
import UIKit
enum InternalErrors: Error {
    case InvalidUserNameAndPassword
}

protocol NooqodyPaymentSceneBusinessLogic: AnyObject {
    func getPaymentLinks()
    func selectChannel(index: Int)
    func checkPaymentStatus()
    func createApplePaySession()
    func createApplePayRequest() -> PKPaymentRequest
    func proccesApplePayPayment(version: String, signature: String,
                                data: String,ephemeralPublicKey:  String,
                                publicKeyHash: String, transactionId: String)
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
    
    var paymenLinktModel: PaymentLinksModel?
    var createApplePayModel: createApplePayModel?
    
   
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

        let patamsString = email+name+phone+desc+code+refrence+amount.description
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
                self.paymenLinktModel = payment
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

extension NooqodyPaymentSceneInteractor{
    func createApplePayRequest() -> PKPaymentRequest{
        
        let request  = PKPaymentRequest()
        request.currencyCode = "QAR" // 1
        request.countryCode = "QA" // 2
        request.merchantIdentifier = "merchant.com.noqoody.applenoqoody" // 3
        request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
        request.supportedNetworks = [.amex, .mada, .masterCard, .visa]// 5
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Nooqody", amount: NSDecimalNumber(value: 1))]
        
        return request
        
    }
    
    func createApplePaySession() {
        guard let sessionId = paymenLinktModel?.sessionID, let uuid = paymenLinktModel?.uuid else {
            return
        }
        self.worker.createAppleSession(sessionID: sessionId, uuid: uuid) { createApplePayModel in
            self.createApplePayModel = createApplePayModel
            self.presenter.presentApplePaySuccess(request: self.createApplePayRequest())
        } failure: { error in
            self.presenter.present(refrence: self.refrence, error: error)
        }

    }
    
     func proccesApplePayPayment(version: String, signature: String, data: String, ephemeralPublicKey: String, publicKeyHash: String, transactionId: String){
        
         self.worker.proccesApplePayPayment(appleSessionID: self.createApplePayModel?.SessionID ?? "", device: UIDevice.current.name, version: version, signature: signature, data: data, ephemeralPublicKey: ephemeralPublicKey, publicKeyHash: publicKeyHash, transactionId: transactionId) { model in
           
             self.presenter.successApplePay(url: model.redirecturl)
           
        } failure: { error in
            self.presenter.present(refrence: self.refrence, error: error)
        }
        
    }
   
}
private extension NooqodyPaymentSceneInteractor {
    func randomString() -> String {
      let letters = "0123456789"
      return String((0..<20).map{ _ in letters.randomElement()! })
    }
}
