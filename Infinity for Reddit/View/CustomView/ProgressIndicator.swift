//
//  ProgressBar.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-11.
//

import SwiftUI

struct ProgressIndicator: View {
    @EnvironmentObject private var themeViewModel: CustomThemeViewModel
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: themeViewModel.currentCustomTheme.colorAccent)))
    }
}
