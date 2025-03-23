//
//  MarkdownViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

import SwiftUI
import MarkdownUI

struct MarkdownViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            //.font()
            .markdownTheme(Theme().link {
                ForegroundColor(Color(hex: themeViewModel.currentCustomTheme.colorAccent))
            })
    }
}
