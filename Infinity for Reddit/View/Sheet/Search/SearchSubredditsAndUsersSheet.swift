//
//  SearchSubredditsAndUsersSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SearchSubredditsAndUsersSheet: View {
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let onSearch: (String) -> Void
    let onThingSelected: (SearchInThing) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Search Subreddits and Users")
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
            
            SearchView { query in
                onSearch(query)
                dismiss()
            }
        }
        .id(accountViewModel.account.username)
    }
}
