//
//  TokenModel.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//

struct TokenModel: Codable {
    let accessToken, tokenType: String?
    let expiresIn: Int?
    let userName, name, role, imageLocation: String?
    let email, issued, expires: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case userName
        case name = "Name"
        case role = "Role"
        case imageLocation = "ImageLocation"
        case email = "Email"
        case issued = ".issued"
        case expires = ".expires"
    }
}
