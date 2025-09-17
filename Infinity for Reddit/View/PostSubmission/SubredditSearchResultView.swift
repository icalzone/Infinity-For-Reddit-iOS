//
// SubredditSearchResultView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-06
        
import SwiftUI

struct SubredditSearchResultView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    @Environment(\.dismiss) var dismiss
    
    private let query: String
    
    init(query: String) {
        self.query = query
    }
    
    var body: some View {
        SubredditListingView(account: accountViewModel.account, query: query) { subreddit in
            postSubmissionContextViewModel.selectedSubreddit = SubscribedSubredditData.fromSubreddit(subreddit, username: accountViewModel.account.username)
            dismiss()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Subreddits")
        .id(accountViewModel.account.username)
        .toolbar {
            NavigationBarMenu()
        }
    }
}

