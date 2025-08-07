//
// UNUserNotificationCenterAsync.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-07
        
import UserNotifications

extension UNUserNotificationCenter {
    func addRequest(_ request: UNNotificationRequest) async throws {
        let settings = await notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            guard try await requestAuthorization(options: [.alert, .sound, .badge]) else {
                throw URLError(.userAuthenticationRequired)
            }
            return
        }
        
        try await self.add(request)
    }
}
