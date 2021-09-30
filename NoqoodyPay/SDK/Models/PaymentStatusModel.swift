//
//  PaymentStatusModel.swift
//  NooqodyPay
//
//  Created by HE on 02/08/2021.
//

import Foundation

public enum TransactionStatus: String, Codable {
    case error
    case success
}

public struct PaymentStatusModel: Codable {
    public let transactionID, responseCode: String?
    public let amount: Int?
    public let transactionStatus: TransactionStatus?
    public let transactionDate, reference, serviceName: String?
    public let mobile, transactionMessage, pun, welcomeDescription: String?
    public let invoiceNo: String?
    public let dollarAmount: Int?
    public let email, payeeName: String?
    public let success: Bool?
    public let code, message: String?
    public let errors: [String]?

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
