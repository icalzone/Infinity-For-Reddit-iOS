//
//  ProxyConfiguration.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-11-30.
//

import Foundation

struct ProxyConfiguration {
    enum ProxyType: Int {
        case http = 0
        case socks = 1
        
        var description: String {
            switch self {
            case .http: return "HTTP"
            case .socks: return "SOCKS"
            }
        }
    }
    
    let host: String
    let port: Int
    let type: ProxyType
    
    init?() {
        guard ProxyUserDefaultsUtils.enableProxy else {
            return nil
        }
        
        let rawHost = ProxyUserDefaultsUtils.proxyHostname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !rawHost.isEmpty else {
            return nil
        }
        
        let rawPort = ProxyUserDefaultsUtils.proxyPort.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let port = Int(rawPort), port > 0 else {
            return nil
        }
        
        guard let proxyType = ProxyType(rawValue: ProxyUserDefaultsUtils.proxyType) else {
            return nil
        }
        
        self.host = rawHost
        self.port = port
        self.type = proxyType
    }
    
    var connectionProxyDictionary: [AnyHashable: Any] {
        switch type {
        case .http:
            return [
                kCFNetworkProxiesHTTPEnable as String: true,
                kCFNetworkProxiesHTTPProxy as String: host,
                kCFNetworkProxiesHTTPPort as String: port,
                "HTTPSEnable": true,
                "HTTPSProxy": host,
                "HTTPSPort": port
            ]
        case .socks:
            return [
                "SOCKSEnable": true,
                "SOCKSProxy": host,
                "SOCKSPort": port
            ]
        }
    }
}
