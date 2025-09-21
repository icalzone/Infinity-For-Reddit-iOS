//
//  SubredditAndUserSearchResultSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SubredditAndUserSearchResultSheet: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedOption = 0
    
    let query: String
    let onSearchInThingSelected: (SearchInThing) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Select a Destination")
                    .primaryText()
                
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .neutralTextButton()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(16)
            }
            
            SegmentedPicker(selectedValue: $selectedOption, values: ["Subreddits", "Users"])
                .padding(4)
            
            TabView(selection: $selectedOption) {
                SubredditListingView(account: accountViewModel.account, query: query) { subreddit in
                    onSearchInThingSelected(SearchInThing.subreddit(SubscribedSubredditData.fromSubreddit(subreddit, username: accountViewModel.account.username)))
                    dismiss()
                }
                .tag(0)
                
                UserListingView(account: accountViewModel.account, query: query) { user in
                    onSearchInThingSelected(SearchInThing.user(SubscribedUserData.fromUser(user, username: accountViewModel.account.username)))
                    dismiss()
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .id(accountViewModel.account.username)
    }
}
