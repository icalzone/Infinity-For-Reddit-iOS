//
//  SelectSearchInThingSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SelectSearchInThingSheet: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @EnvironmentObject private var navigationManager: NavigationManager
    @Environment(\.dismiss) private var dismiss
    
    let onSearchThing: () -> Void
    let onSelectThing: (SearchInThing) -> Void
    
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
                    
                    Button {
                        onSearchThing()
                        dismiss()
                    } label: {
                        SwiftUI.Image(systemName: "magnifyingglass")
                            .primaryIcon()
                    }
                }
                .padding(16)
            }
            
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
    }
}
