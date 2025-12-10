//
//  CustomThemeListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-02-20.
//

import SwiftUI
import Swinject
import GRDB

struct CustomThemeListingView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject private var customThemeListingViewModel: CustomThemeListingViewModel
    
    init() {
        _customThemeListingViewModel = StateObject(
            wrappedValue: CustomThemeListingViewModel(
                customThemeListingRepository: CustomThemeListingRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
            List {
                ForEach(customThemeListingViewModel.customThemes, id: \.self.id) { customTheme in
                    ThemeListItem(themeName: customTheme.name, primaryColor: Color(hex: customTheme.colorPrimary)) {
                        navigationManager.append(CustomThemeSettingsViewNavigation.customizeCustomTheme(customTheme: customTheme))
                    }
                    .listPlainItemNoInsets()
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            customThemeListingViewModel.deleteTheme(customTheme)
                        } label: {
                            Text("Delete")
                                .foregroundStyle(.white)
                        }
                        .tint(.red)
                    }
                }
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Manage Themes")
    }
    
    struct ThemeListItem: View {
        let themeName: String
        let primaryColor: Color
        let onTap: () -> Void
        
        var body: some View {
            TouchRipple(action: onTap) {
                HStack(spacing: 0) {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 24, height: 24)
                    
                    Spacer()
                        .frame(width: 24)
                    
                    Text(themeName)
                    
                    Spacer()
                }
                .padding(16)
                .contentShape(Rectangle())
            }
        }
    }
}
