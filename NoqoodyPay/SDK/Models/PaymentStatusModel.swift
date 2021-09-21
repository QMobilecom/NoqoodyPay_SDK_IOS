//
//  PaymentStatusModel.swift
//  NooqodyPay
//
//  Created by HE on 02/08/2021.
//

import Foundation

enum TransactionStatus: String, Codable {
    case error
    case success
}

struct PaymentStatusModel: Codable {
    let transactionID, responseCode: String?
    let amount: Int?
    let transactionStatus: TransactionStatus?
    let transactionDate, reference, serviceName: String?
    let mobile, transactionMessage, pun, welcomeDescription: String?
    let invoiceNo: String?
    let dollarAmount: Int?
    let email, payeeName: String?
    let success: Bool?
    let code, message: String?
    let errors: [String]?

    enum CodingKeys: String, CodingKey {
        case transactionID = "TransactionID"
        case responseCode = "ResponseCode"
        case amount = "Amount"
        case transactionDate = "TransactionDate"
        case transactionStatus = "TransactionStatus"
        case reference = "Reference"
        case serviceName = "ServiceName"
        case mobile = "Mobile"
        case transactionMessage = "TransactionMessage"
        case pun = "PUN"
        case welcomeDescription = "description"
        case invoiceNo = "InvoiceNo"
        case dollarAmount = "DollarAmount"
        case email = "Email"
        case payeeName = "PayeeName"
        case success, code, message, errors
    }
}
