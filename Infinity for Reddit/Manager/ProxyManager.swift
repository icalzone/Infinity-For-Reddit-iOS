//
//  ProxyManager.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-11-25.
//

import Foundation
import GCDWebServer

final class ProxyManager {
    static let shared = ProxyManager()

    private let controlQueue = DispatchQueue(label: "com.docilealligator.infinityforreddit.proxymanager.control", qos: .default)
    private var configuration: ProxyConfiguration?
    private var proxyServer: ProxyServer?

    private static let ensureGCDWebServerInitialized: Void = {
        let initialize = {
            _ = GCDWebServer()
        }

        if Thread.isMainThread {
            initialize()
        } else {
            DispatchQueue.main.sync(execute: initialize)
        }
    }()

    private init() {
        _ = ProxyManager.ensureGCDWebServerInitialized
        controlQueue.sync {
            if let proxyConfiguration = ProxyConfiguration() {
                self.configuration = proxyConfiguration
                configureProxyServer(with: proxyConfiguration)
            } else {
                self.configuration = nil
                print("Proxy: Proxy disabled or misconfigured")
            }
        }
    }

    private func configureProxyServer(with configuration: ProxyConfiguration) {
        if configuration.type == .direct {
            print("Proxy: Direct proxy selected, requests will bypass the proxy server")
            return
        }

        guard let proxyDictionary = configuration.connectionProxyDictionary,
              let host = configuration.host,
              let port = configuration.port else {
            print("Proxy: Proxy enabled but missing host/port configuration")
            return
        }

        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.connectionProxyDictionary = proxyDictionary
        sessionConfiguration.timeoutIntervalForRequest = ProxyUtils.timeoutRequest
        sessionConfiguration.timeoutIntervalForResource = ProxyUtils.timeoutResource

        print("Proxy: URLSession configured with proxy: \(host):\(port) (\(configuration.type.description))")

        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .userInteractive

        let session = URLSession(configuration: sessionConfiguration,
                                 delegate: nil,
                                 delegateQueue: delegateQueue)
        let service = URLSessionProxyService(session: session)
        proxyServer = ProxyServer(service: service)
    }

    private func startLocked() {
        guard let configuration, configuration.type != .direct else {
            return
        }
        proxyServer?.start()
    }

    private func stopLocked() {
        proxyServer?.stop()
    }

    func start() {
        controlQueue.async { [weak self] in
            self?.startLocked()
        }
    }

    func stop() {
        controlQueue.async { [weak self] in
            self?.stopLocked()
        }
    }

    func proxyURL(_ url: URL) -> URL {
        return controlQueue.sync {
            guard let configuration,
                  configuration.type != .direct else { return url }

            let ext = url.pathExtension.lowercased()
            guard ProxyResourceFormat(rawValue: ext) != nil,
                  let proxied = proxyServer?.reverseProxyURL(from: url) else {
                #if DEBUG
                print("ProxyManager bypassing proxy for extension:", ext.isEmpty ? "<none>" : ext, url.absoluteString)
                #endif
                return url
            }

            print("Proxy: Proxied URL:\n   Original: \(url.absoluteString)\n   Proxied:  \(proxied.absoluteString)")

            return proxied
        }
    }


    func reloadConfiguration() {
        controlQueue.async { [weak self] in
            guard let self else {
                return
            }

            self.stopLocked()
            self.proxyServer = nil

            guard let newConfiguration = ProxyConfiguration() else {
                self.configuration = nil
                print("Proxy: Proxy disabled or misconfigured")
                return
            }

            self.configuration = newConfiguration
            self.configureProxyServer(with: newConfiguration)
            self.startLocked()
        }
    }
}
