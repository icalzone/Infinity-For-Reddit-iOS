//
//  SelectSearchInThingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-20.
//

import SwiftUI

struct SelectSearchInThingView: View {
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @Environment(\.dismiss) private var dismiss
    
    let onSelectThing: (SearchInThing) -> Void
    
    var body: some View {
        Group {
            if accountViewModel.account.isAnonymous() {
                AnonymousSubscriptionsView() { searchInThing in
                    onSelectThing(searchInThing)
                    dismiss()
                }
                .setUpHomeTabViewChildNavigationBar()
            } else {
                SubscriptionsView()  { searchInThing in
                    onSelectThing(searchInThing)
                    dismiss()
                }
                .setUpHomeTabViewChildNavigationBar()
            }
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select")
    }
}
