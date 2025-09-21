//
//  SearchSubredditsAndUsersView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SearchSubredditsAndUsersView: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let onSearch: (String) -> Void
    let onThingSelected: (SearchInThing) -> Void
    
    var body: some View {
        SearchView { query in
            onSearch(query)
            dismiss()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Search Subreddits and Users")
        .id(accountViewModel.account.username)
    }
}
