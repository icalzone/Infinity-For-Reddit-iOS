//
//  ProxyParameters.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-11-26.
//

import Alamofire
import Foundation

enum ProxyUtils {
    static let serverDefaultPort: UInt = 9876
    static let serverLoopbackHost = "127.0.0.1"
    static let serverOriginURLKey = "__video_origin_url"

    static let timeoutRequest: TimeInterval = 30
    static let timeoutResource: TimeInterval = 300

    static func applyProxyIfNeeded(configuration: URLSessionConfiguration) {
        guard let proxyConfiguration = ProxyConfiguration() else {
            configuration.connectionProxyDictionary = nil
            return
        }

        configuration.connectionProxyDictionary = proxyConfiguration.connectionProxyDictionary
        configuration.timeoutIntervalForRequest = timeoutRequest
        configuration.timeoutIntervalForResource = timeoutResource
    }

    static func makeSession(configuration: URLSessionConfiguration = .af.default,
                            interceptor: RequestInterceptor? = nil) -> Session {
        let mutableConfiguration = configuration
        applyProxyIfNeeded(configuration: mutableConfiguration)
        return Session(configuration: mutableConfiguration, interceptor: interceptor)
    }
}
