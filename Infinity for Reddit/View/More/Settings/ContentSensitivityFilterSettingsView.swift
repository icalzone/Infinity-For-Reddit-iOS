//
// ContentSensitivityFilterSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct ContentSensitivityFilterSettingsView: View {
    @Environment(\.dependencyManager) private var dependencyManager: Container
    
    var body: some View {
        Text("Content Sensitivity Filter")
    }
}
