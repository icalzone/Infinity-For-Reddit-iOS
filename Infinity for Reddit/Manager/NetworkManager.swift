//
//  NetworkManager.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-08.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    @Published var isWifiConnected: Bool = false

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isWifiConnected = (path.usesInterfaceType(.wifi) && path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
