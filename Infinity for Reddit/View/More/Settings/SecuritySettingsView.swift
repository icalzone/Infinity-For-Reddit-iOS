//
// SecuritySettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct SecuritySettingsView: View {
    @AppStorage(SecurityUserDefaultsUtils.appLockKey, store: .security) private var appLock: Bool = false
    @AppStorage(SecurityUserDefaultsUtils.appLockTimeoutKey, store: .security) private var appLockTimeout: Int = 600000
    
    var body: some View {
        RootView {
            List {
                TogglePreference(isEnabled: $appLock, title: "App Lock")
                    .listPlainItemNoInsets()
                
                BarebonePickerPreference(
                    selected: $appLockTimeout,
                    items: SecurityUserDefaultsUtils.appLockTimeouts,
                    title: "App Lock Timeout"
                ) { timeout in
                    SecurityUserDefaultsUtils.appLockTimeoutsText[SecurityUserDefaultsUtils.appLockTimeouts.firstIndex(of: timeout) ?? 4]
                }
                .listPlainItemNoInsets()
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Security")
    }
}
