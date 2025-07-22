//
//  InboxConversationView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-21.
//

import SwiftUI

struct InboxConversationView: View {
    @StateObject var inboxConversationViewModel: InboxConversationViewModel
    
    init(inbox: Inbox) {
        _inboxConversationViewModel = StateObject(
            wrappedValue: InboxConversationViewModel(
                inbox: inbox,
                inboxConversationRepository: InboxConversationRepository()
            )
        )
    }
    
    var body: some View {
        List {
            Text(inboxConversationViewModel.inbox.body)
            
            if let replies = inboxConversationViewModel.inbox.replies?.data?.inboxes {
                ForEach(replies, id: \.id) { reply in
                    Text(reply.body)
                }
            }
        }
        .themedList()
        .themedNavigationBar()
    }
}

struct InboxConversationMe: View {
    var body: some View {
        EmptyView()
    }
}

struct InboxConversationThem: View {
    var body: some View {
        EmptyView()
    }
}
