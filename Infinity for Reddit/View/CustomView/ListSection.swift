//
//  ListSection.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-29.
//

import SwiftUI

struct ListSection<Content: View>: View {
    @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
    
    let title: String
    let padding: CGFloat
    var content: Content
    
    init(
        title: String,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        Section {
            content
        } header: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, padding)
                .background(Color(hex: customThemeViewModel.currentCustomTheme.backgroundColor))
                .listSectionHeader()
        }
        .listPlainItemNoInsets()
    }
}
