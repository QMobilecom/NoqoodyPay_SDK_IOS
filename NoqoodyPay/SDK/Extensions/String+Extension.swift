//
//  String+Extension.swift
//  NooqodyPay
//
//  Created by HE on 17/07/2021.
//

import Foundation
import CommonCrypto

extension String {

    func formatted(with args: [String]?) -> String {
        guard let args = args, args.count > 0 else {
            return self
        }

        var data = self
        for i in 0...args.count - 1 {
            data =  data.replacingOccurrences(of: "{\(i)}", with: args[i])
        }
        return data
    }
}

enum CryptoAlgorithm {

    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {

    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: algorithm.digestLength)
        CCHmac(algorithm.HMACAlgorithm, cKey!, strlen(cKey!), cData!, strlen(cData!), result)
        let hmacData: Data = Data(bytes: result, count: Int(algorithm.digestLength))
        let hmacBase64 = hmacData.base64EncodedString()
        return String(hmacBase64)
    }
}
