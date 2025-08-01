//
//  FilledCardView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-31.
//

import SwiftUI

struct FilledCardView<Content: View>: View {
    @EnvironmentObject var customThemeViewModel: CustomThemeViewModel
    
    var cornerRadius: CGFloat = 12
    var content: Content
    
    init(cornerRadius: CGFloat = 12, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(hex: customThemeViewModel.currentCustomTheme.filledCardViewBackgroundColor))
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
