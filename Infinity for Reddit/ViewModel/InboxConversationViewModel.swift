//
//  InboxConversationViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-21.
//

import Foundation

class InboxConversationViewModel: ObservableObject {
    @Published var inbox: Inbox
    
    private let inboxConversationRepository: InboxConversationRepositoryProtocol
    
    init(inbox: Inbox, inboxConversationRepository: InboxConversationRepositoryProtocol) {
        self.inbox = inbox
        self.inboxConversationRepository = inboxConversationRepository
    }
}
