//
//  SubscribedSubredditListingMultiSelectionSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import SwiftUI

struct SubscribedSubredditListingMultiSelectionSheet: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSearchSubredditsAndUsersView: Bool = false
    
    let onSelectThing: (SearchInThing) -> Void
    
    var body: some View {
        ZStack {
            if accountViewModel.account.isAnonymous() {
                AnonymousSubscriptionsView() { searchInThing in
                    onSelectThing(searchInThing)
                    dismiss()
                }
            } else {
                SubscriptionsView(subscriptionSelectionMode: .subredditAndUserInCustomFeed(onSelectMultipleSubscriptions: { subredditAndUsersInCustomFeed in
                    dismiss()
                }))
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Subscriptions")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .navigationBarPrimaryText()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearchSubredditsAndUsersView = true
                } label: {
                    SwiftUI.Image(systemName: "magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $showSearchSubredditsAndUsersView) {
            NavigationStack {
                SearchSubredditsAndUsersSheet { searchInThing in
                    onSelectThing(searchInThing)
                    dismiss()
                }
            }
        }
    }
}
