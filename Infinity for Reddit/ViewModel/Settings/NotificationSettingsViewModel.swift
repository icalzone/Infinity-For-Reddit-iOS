//
//  NotificationSettingsViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-13.
//

import Foundation

class NotificationSettingsViewModel {
    func enableNotification(enable: Bool) {
        
    }
    
    func updateNotificationInterval() {
        NotificationCenter.default.post(name: .notificationIntervalChanged, object: nil)
    }
}
