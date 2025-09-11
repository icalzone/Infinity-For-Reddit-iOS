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
    @StateObject private var interfaceSettingsViewModel = InterfaceSettingsViewModel()
    
    @AppStorage(InterfaceUserDefaultsUtils.voteButtonsOnTheRightKey, store: .interface) private var voteButtonsOnTheRight: Bool = false
    @AppStorage(InterfaceUserDefaultsUtils.showAbsoluteNumberOfVotesKey, store: .interface) private var showAbsoluteNumberOfVotes: Bool = true
    
    var body: some View {
        List {
            NavigationLink(destination: FontInterfaceView()) {
                Label("Font", systemImage: "textformat.size")
            } 
            NavigationLink(destination: ImmersiveInterfaceView()) {
                Text("Immersive Interface").padding(.leading, 44.5)
            }
            NavigationLink(destination: NavigationDrawerInterfaceView()) {
                Text("Navigation Drawer").padding(.leading, 44.5)
            }
            Toggle("Hide Subreddit Description", isOn: $interfaceSettingsViewModel.hideSubredditDescription).padding(.leading, 44.5)
            Toggle("Use Bottom Toolbar in Media Viewer", isOn: $interfaceSettingsViewModel.useBottomToolbarInMediaViewer).padding(.leading, 44.5)
            Picker("Default Search Result Tab", selection: $interfaceSettingsViewModel.defaultSearchResultTab){
                ForEach(0..<interfaceSettingsViewModel.searchResultTabs.count, id: \.self) { index in
                    Text(interfaceSettingsViewModel.searchResultTabs[index]).tag(index)
                }
            }
            .padding(.leading, 44.5)
            NavigationLink(destination: InterfaceTimeFormatView()) {
                Text("Time Format").padding(.leading, 44.5)
            }
            NavigationLink(destination: InterfacePostSettingsView()) {
                Text("Post").padding(.leading, 44.5)
            }
            NavigationLink(destination: InterfacePostDetailsSettingsView()) {
                Text("Post Details").padding(.leading, 44.5)
            }
            NavigationLink(destination: InterfaceCommentSettingsView()) {
                Text("Comment").padding(.leading, 44.5)
            }
            
            Section(header: Text("Post and Comment").listSectionHeader()) {
                TogglePreference(isEnabled: $voteButtonsOnTheRight, title: "Vote Buttons on the Right")
                    .listPlainItemNoInsets()
                
                TogglePreference(isEnabled: $showAbsoluteNumberOfVotes, title: "Show Absolute Number of Votes")
                    .listPlainItemNoInsets()
            }
            .listPlainItem()
        }
        .themedList()
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Interface")
    }
}


