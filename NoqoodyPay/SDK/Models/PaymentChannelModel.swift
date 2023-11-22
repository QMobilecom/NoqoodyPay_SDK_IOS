//
//  PaymentChannelModel.swift
//  NooqodyPay
//
//  Created by HE on 01/08/2021.
//

struct PaymentChannelModel: Codable {
    let paymentChannels: [PaymentChannel]?
    let transactionDetail: TransactionDetail?
    let success: Bool?
    let code, message: String?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case paymentChannels = "PaymentChannels"
        case transactionDetail = "TransactionDetail"
        case success, code, message, errors
    }
}

struct PaymentChannel: Codable {
    let id: Int?
    let channelName: String?
    let imageLocation: String?
    let paymentURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case channelName = "ChannelName"
        case imageLocation = "ImageLocation"
        case paymentURL = "PaymentURL"
    }
}

struct TransactionDetail: Codable {
    let merchantName, transactionDescription: String?
    let amount: Double?
    let reference, mobileNumber, email, customerEmail: String?
    let customerMobile, customerName: String?
    let merchantLogo: String?

    enum CodingKeys: String, CodingKey {
        case merchantName = "MerchantName"
        case transactionDescription = "TransactionDescription"
        case amount = "Amount"
        case reference = "Reference"
        case mobileNumber = "MobileNumber"
        case email = "Email"
        case customerEmail = "CustomerEmail"
        case customerMobile = "CustomerMobile"
        case customerName = "CustomerName"
        case merchantLogo = "MerchantLogo"
    }
}
