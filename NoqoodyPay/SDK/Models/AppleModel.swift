//
//  AppleModel.swift
//  NoqoodyPay
//
//  Created by mahmoud ali on 22/11/2023.
//

import Foundation

struct  createApplePayModel: Codable{
    var SessionID: String?
    var redirecturl: String?
    var success: Bool?
    var code: String?
    var message: String?
    var errors: [String]?
}

struct PaymentAppleTokenModel: Codable{
    var version:String?
    var signature: String?
    var header: PaymentAppleHeaderModel?
    var data: String?
    
}

struct PaymentAppleHeaderModel: Codable{
    var ephemeralPublicKey: String?
    var publicKeyHash: String?
    var transactionId: String?
}
