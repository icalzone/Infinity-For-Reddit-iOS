//
// HomeViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-07

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var hasNewMessages: Bool = false
    @Published var inboxNavigationTarget: InboxNavigationTarget?
    private var refreshTimer: AnyCancellable?
    
    struct InboxNavigationTarget: Equatable {
        let viewMessage: Bool
    }
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .notificationIntervalChanged,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.startAutoRefresh()
            }
        }
    }
    
    func refreshInboxMessages() async {
        print("Foreground Refresh: Pull & notify via unified pipeline.")
        let newMessagesAvailable = await PullNotificationBackgroundTaskManager.shared.pullNotificationsForAllAccounts()
    }
    
    func startAutoRefresh() {
        stopAutoRefresh()
        
        let refreshInterval = NotificationUserDefaultsUtils.notificationInterval
        refreshTimer = Timer.publish(every: TimeInterval(refreshInterval * 60), on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                _ = Task {
                    await self.refreshInboxMessages()
                }
            }
    }
    
    func stopAutoRefresh() {
        refreshTimer?.cancel()
        refreshTimer = nil
    }
}
