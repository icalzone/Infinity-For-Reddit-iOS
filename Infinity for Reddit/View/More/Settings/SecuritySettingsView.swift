//
// SecuritySettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB
import LocalAuthentication

struct SecuritySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage(SecurityUserDefaultsUtils.appLockKey, store: .security) private var appLock: Bool = false
    @AppStorage(SecurityUserDefaultsUtils.appLockTimeoutKey, store: .security) private var appLockTimeout: Int = 600000
    
    @State private var authenticated: Bool = false
    @State private var showSettings: Bool = false
    
    var body: some View {
        RootView {
            if showSettings {
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
            } else {
                ZStack{}
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Security")
        .onAppear {
            authenticate()
        }
        .onChange(of: authenticated) { _, newValue in
            if newValue {
                Task {
                    try? await Task.sleep(for: .seconds(1))
                    showSettings = true
                }
            } else {
                dismiss()
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We use Face ID to confirm it’s you before entering security settings."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                authenticated = success
            }
        }
    }
}
