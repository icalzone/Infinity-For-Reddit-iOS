//
//  ListViewModifier.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-21.
//

import SwiftUI

struct ListCustomThemeViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}

struct ListPlainItemThemeViewModifier: ViewModifier {
    @EnvironmentObject var themeViewModel: CustomThemeViewModel
    
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}
