//
//  SecurityUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-12-05.
//

import Foundation

class SecurityUserDefaultsUtils {
    static let appLockKey = "app_lock"
    static var appLock: Bool {
        return UserDefaults.security?.bool(forKey: appLockKey, false) ?? false
    }
    
    static let appLockTimeoutKey = "app_lock_timeout"
    static var appLockTimeout: Int {
        return UserDefaults.security?.integer(forKey: appLockTimeoutKey, 600000) ?? 600000
    }
    static let appLockTimeouts: [Int] = [
        0,
        60000,
        120000,
        300000,
        600000,
        900000,
        1200000,
        1800000,
        3600000,
        7200000,
        10800000,
        14400000,
        18000000,
        21600000,
        43200000,
        86400000
    ]
    static let appLockTimeoutsText: [String] = [
        "Immediately",
        "1 minute",
        "2 minutes",
        "5 minutes",
        "10 minutes",
        "15 minutes",
        "20 minutes",
        "30 minutes",
        "1 hour",
        "2 hours",
        "3 hours",
        "4 hours",
        "5 hours",
        "6 hours",
        "12 hours",
        "24 hours"
    ]
    
    private static let lastForegroundTimeKey = "last_foreground_time"
    static func saveLastForegroundTime() {
        UserDefaults.security?.set(Utils.getCurrentTimeEpoch(), forKey: lastForegroundTimeKey)
    }
    static func getLastForegroundTime() -> Int {
        return UserDefaults.security?.integer(forKey: lastForegroundTimeKey) ?? 0
    }
}
