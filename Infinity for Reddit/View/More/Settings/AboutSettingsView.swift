//
// AboutSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI

struct AboutSettingsView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        RootView {
            ScrollView {
                VStack(spacing: 0) {
                    PreferenceEntry(
                        title: "Acknowledgement"
                    ) {
                        navigationManager.append(AboutSettingsViewNavigation.acknowledgement)
                    }
                    
                    PreferenceEntry(
                        title: "Credits"
                    ) {
                        navigationManager.append(AboutSettingsViewNavigation.credits)
                    }
                    
                    PreferenceEntry(
                        title: "Open Source",
                        subtitle: "If you enjoy this app, consider starring it on GitHub."
                    ) {
                        navigationManager.openLink("https://github.com/foxanastudio/Infinity-For-Reddit-iOS")
                    }
                    
                    PreferenceEntry(
                        title: "Rate Us",
                        subtitle: "Love the app? A 5-star rating would totally make our day!"
                    ) {
                        navigationManager.openLink("itms-apps://apps.apple.com/us/app/infinity-for-reddit/id6759064642")
                    }
                    
                    PreferenceEntry(
                        title: "Email",
                        subtitle: "support@foxanastudio.com"
                    ) {
                        if let url = URL(string: "mailto:support@foxanastudio.com") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    PreferenceEntry(
                        title: "Developer Reddit Account",
                        subtitle: "u/Hostilenemy"
                    ) {
                        navigationManager.append(AppNavigation.userDetails(username: "Hostilenemy"))
                    }
                    
                    PreferenceEntry(
                        title: "Subreddit",
                        subtitle: "r/Infinity_For_Reddit"
                    ) {
                        navigationManager.append(AppNavigation.subredditDetails(subredditName: "Infinity_For_Reddit"))
                    }
                    
                    ShareLink(
                        item: "Want an infinitely better Reddit experience? Try Infinity for Reddit now https://apps.apple.com/us/app/infinity-for-reddit/id6759064642"
                    ) {
                        PreferenceEntry(
                            title: "Share this app with friends!",
                            subtitle: "Let them join the fun!"
                        )
                    }
                    
                    PreferenceEntry(
                        title: "Infinity For Reddit",
                        subtitle: "Version \(Bundle.main.appVersion)"
                    )
                }
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("About")
    }
}
