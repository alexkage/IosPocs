//
//  OTPAlgorithm.swift
//  IosPocs
//
//  Created by Jose Flavio Quispe Irrazabal on 20/2/17.
//  Copyright © 2019 AlexKage. All rights reserved.
//  Sauce: https://github.com/lachlanbell/SwiftOTP/blob/master/SwiftOTP/OTPAlgorithm.swift

import Foundation

/// Hash algorithm to use for one time password generation
public enum OTPAlgorithm {
    case sha1
    case sha256
    case sha512
    
    /// CryptoSwift HMAC variant equivalent
    internal var hmacVariant: HMAC.Variant {
        switch self {
        case .sha1:
            return HMAC.Variant.sha1
        case .sha256:
            return HMAC.Variant.sha256
        case .sha512:
            return HMAC.Variant.sha512
        }
    }
}
