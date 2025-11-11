//
// InterfaceSettingsView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import SwiftUI
import Swinject
import GRDB

struct InterfaceSettingsView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    
    @StateObject private var interfaceSettingsViewModel = InterfaceSettingsViewModel()
    
    @AppStorage(InterfaceUserDefaultsUtils.voteButtonsOnTheRightKey, store: .interface) private var voteButtonsOnTheRight: Bool = false
    @AppStorage(InterfaceUserDefaultsUtils.showAbsoluteNumberOfVotesKey, store: .interface) private var showAbsoluteNumberOfVotes: Bool = true
    
    var body: some View {
        RootView {
            List {
                PreferenceEntry(
                    title: "Font",
                    icon: "textformat.size"
                ) {
                    navigationManager.append(InterfaceSettingsViewNavigation.font)
                }
                .listPlainItemNoInsets()
                
                Toggle("Hide Subreddit Description", isOn: $interfaceSettingsViewModel.hideSubredditDescription).padding(.leading, 44.5)
                Picker("Default Search Result Tab", selection: $interfaceSettingsViewModel.defaultSearchResultTab){
                    ForEach(0..<interfaceSettingsViewModel.searchResultTabs.count, id: \.self) { index in
                        Text(interfaceSettingsViewModel.searchResultTabs[index]).tag(index)
                    }
                }
                .padding(.leading, 44.5)
                
                PreferenceEntry(
                    title: "Time Format",
                    icon: "clock"
                ) {
                    navigationManager.append(InterfaceSettingsViewNavigation.timeFormat)
                }
                .listPlainItemNoInsets()
                
                PreferenceEntry(
                    title: "Post"
                ) {
                    navigationManager.append(InterfaceSettingsViewNavigation.post)
                }
                .listPlainItemNoInsets()
                
                PreferenceEntry(
                    title: "Post Details"
                ) {
                    navigationManager.append(InterfaceSettingsViewNavigation.postDetails)
                }
                .listPlainItemNoInsets()
                
                PreferenceEntry(
                    title: "Comment",
                    icon: "text.bubble"
                ) {
                    navigationManager.append(InterfaceSettingsViewNavigation.comment)
                }
                .listPlainItemNoInsets()
                
                CustomListSection("Post and Comment") {
                    TogglePreference(isEnabled: $voteButtonsOnTheRight, title: "Vote Buttons on the Right")
                        .listPlainItemNoInsets()
                    
                    TogglePreference(isEnabled: $showAbsoluteNumberOfVotes, title: "Show Absolute Number of Votes")
                        .listPlainItemNoInsets()
                }
            }
            .themedList()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Interface")
    }
}


