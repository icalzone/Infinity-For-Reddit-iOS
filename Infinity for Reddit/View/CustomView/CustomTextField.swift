//
//  CustomTextField.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-01.
//

import SwiftUI

struct CustomTextField: View {
    @EnvironmentObject var customThemeViewModel: CustomThemeViewModel
    
    @Binding var text: String
    var placeholder: String
    
    init(_ placeholder: String = "", text: Binding<String>) {
        self.placeholder = placeholder
        _text = text
    }
    
    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
                .foregroundStyle(Color(hex: customThemeViewModel.currentCustomTheme.secondaryTextColor))
        )
        .primaryText()
        .tint(Color(hex: customThemeViewModel.currentCustomTheme.colorPrimary))
    }
}
