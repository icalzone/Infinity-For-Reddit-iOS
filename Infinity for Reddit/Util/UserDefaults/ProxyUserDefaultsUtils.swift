//
//  ProxyUserDefaultsUtils.swift
//  Infinity for Reddit
//
//  Created by Joeylr on 2025-11-25.
//

import Foundation

class ProxyUserDefaultsUtils {
    static let enableProxyKey = "enable_proxy"
    static var enableProxy: Bool {
        return UserDefaults.proxy.bool(forKey: enableProxyKey)
    }
    
    static let proxyTypeKey = "proxy_type"
    static var proxyType : Int {
        return UserDefaults.proxy.integer(forKey: proxyTypeKey)
    }
    static let proxyTypes: [Int] = [0, 1]
    static let proxyTypesText: [String] = ["HTTP", "SOCKS"]
    
    static let proxyHostnameKey = "proxy_hostname"
    static var proxyHostname : String {
        return UserDefaults.proxy.string(forKey: proxyHostnameKey) ?? ""
    }
    
    static let proxyPortKey = "proxy_port"
    static var proxyPort : String {
        return UserDefaults.proxy.string(forKey: proxyPortKey) ?? ""
    }
}
