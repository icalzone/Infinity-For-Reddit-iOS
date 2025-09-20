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
    
    private let userDefaults: UserDefaults
    
    init() {
        guard let resolvedUserDefaults = DependencyManager.shared.container.resolve(UserDefaults.self) else {
            fatalError("Failed to resolve UserDefaults")
        }
        self.userDefaults = resolvedUserDefaults
    }
    
    func refreshInboxMessages() async {
        print("Foreground Refresh: Pull & notify via unified pipeline.")
        let newMessagesAvailable = await BackgroundTasksManager.shared.refreshAndNotifyAllAccounts()
        if hasNewMessages != newMessagesAvailable { hasNewMessages = newMessagesAvailable}
        print(newMessagesAvailable ? "Foreground Refresh: New message found! UI will be updated."
              : "Foreground Refresh: No new message.")
    }
    
    func markInboxAsRead() {
        print("User viewed inbox, clearing badge and advancing last seen.")
        hasNewMessages = false
    }
    
    func startAutoRefresh() {
        refreshTimer = Timer.publish(every: 30, on: .main, in: .common)
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
