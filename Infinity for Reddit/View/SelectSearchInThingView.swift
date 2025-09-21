//
//  SelectSearchInThingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SelectSearchInThingView: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    let onSearchThing: () -> Void
    let onSelectThing: (SearchInThing) -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Cancel")
                    .neutralTextButton()
                    .onTapGesture {
                        dismiss()
                    }
                
                Text("Select a Destination")
                    .primaryText()
                
                Button {
                    onSearchThing()
                    dismiss()
                } label: {
                    SwiftUI.Image(systemName: "magnifyingglass")
                        .primaryIcon()
                }
            }
            .padding(16)
            
            if accountViewModel.account.isAnonymous() {
                AnonymousSubscriptionsView() { searchInThing in
                    onSelectThing(searchInThing)
                    dismiss()
                }
            } else {
                SubscriptionsView()  { searchInThing in
                    onSelectThing(searchInThing)
                    dismiss()
                }
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select a Destination")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    navigationManager.path.removeLast()
                    DispatchQueue.main.async {
                        navigationManager.path.append(SearchSubredditAndUserNavigation.searchSubredditAndUser)
                    }
                } label: {
                    SwiftUI.Image(systemName: "magnifyingglass")
                        .navigationBarButton()
                }
            }
        }
    }
}
