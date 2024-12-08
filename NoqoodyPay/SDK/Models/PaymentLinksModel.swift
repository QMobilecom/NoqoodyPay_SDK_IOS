//
//  PaymentLinksModel.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//

struct PaymentLinksModel: Codable {
    let paymentURL: String?
    let projectCode, reference, welcomeDescription: String?
    let amount: Int?
    let customerEmail, customerName, customerMobile, sessionID: String?
    let uuid: String?
    let success: Bool?
    let code, message: String?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case paymentURL = "PaymentUrl"
        case projectCode = "ProjectCode"
        case reference = "Reference"
        case welcomeDescription = "Description"
        case amount = "Amount"
        case customerEmail = "CustomerEmail"
        case customerName = "CustomerName"
        case customerMobile = "CustomerMobile"
        case sessionID = "SessionId"
        case uuid = "Uuid"
        case success, code, message, errors
    }
}
