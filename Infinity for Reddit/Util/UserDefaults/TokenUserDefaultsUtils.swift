//
//  TokenUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-15.
//

import Foundation

class TokenUserDefaultsUtils {
    static let redgifsKey = "redgifs"
    static var redgifs: String {
        return UserDefaults.token.string(forKey: redgifsKey) ?? ""
    }
    static func setRedgifs(_ value: String) {
        UserDefaults.token.set(value, forKey: redgifsKey)
    }
}
