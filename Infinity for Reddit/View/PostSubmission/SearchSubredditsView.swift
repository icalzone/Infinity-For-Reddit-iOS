//
// SubredditSearchView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27
        
import SwiftUI

struct SearchSubredditsView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        SearchView { query in
            navigationManager.path.removeLast()
            navigationManager.path.append(AppNavigation.searchSubredditsResults(query: query))
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Search")
        .id(accountViewModel.account.username)
    }
}
