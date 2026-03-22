//
//  InboxConversationView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-21.
//

import SwiftUI

struct InboxConversationView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var navigationBarMenuManager: NavigationBarMenuManager
    @EnvironmentObject private var accountViewModel: AccountViewModel
    @EnvironmentObject private var snackbarManager: SnackbarManager
    
    @StateObject var inboxConversationViewModel: InboxConversationViewModel
    
    @State private var scrollToBottomTrigger: Bool = false
    @State private var messageText: String = ""
    @State private var sendMessageTask: Task<Void, Never>?
    @State private var navigationBarMenuKey: UUID?
    @FocusState private var isInputActive: Bool
    
    init(inbox: Inbox) {
        _inboxConversationViewModel = StateObject(
            wrappedValue: InboxConversationViewModel(
                inbox: inbox,
                inboxConversationRepository: InboxConversationRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    List {
                        let conversations = inboxConversationViewModel.conversations
                        
                        ForEach(Array(conversations.enumerated()), id: \.element.id) { index, inbox in
                            // Remember the conversations is reversed.
                            let isLastFromSender = index == 0 || conversations[index - 1].author != inbox.author
                            
                            ChatBubble(isSentMessage: inbox.author == accountViewModel.account.username, shouldShowTail: isLastFromSender) {
                                Text(inbox.body)
                            }
                            .listPlainItemNoInsets()
                            .rotationEffect(.degrees(180))
                            .id(inbox.id)
                        }
                    }
                    .rotationEffect(.degrees(180))
                    .themedList()
                    .scrollIndicators(.hidden)
                    .onTapGesture {
                        isInputActive = false
                    }
                    .onChange(of: inboxConversationViewModel.listScrollTarget) {
                        guard let target = inboxConversationViewModel.listScrollTarget else { return }
                        
                        proxy.scrollTo(target, anchor: .bottom)
                    }
                }
                
                if inboxConversationViewModel.fullNameToReplyTo != nil {
                    // It shouldn't happen but still
                    HStack(spacing: 8) {
                        TextField("Type a message...", text: $messageText)
                            .focused($isInputActive)
                            .padding(12)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .submitLabel(.send)
                            .onSubmit {
                                sendMessage()
                            }

                        Button(action: {
                            sendMessage()
                        }) {
                            SwiftUI.Image(systemName: "paperplane.fill")
                                .foregroundColor(messageText.isEmpty ? .gray : .blue)
                                .padding(10)
                        }
                        .disabled(messageText.isEmpty || sendMessageTask != nil)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemBackground))
                }
            }
        }
        .themedNavigationBar()
        .applyIf(inboxConversationViewModel.recepient != nil) {
            $0.addTitleToInlineNavigationBar(inboxConversationViewModel.recepient!)
        }
        .toolbar {
            NavigationBarMenu()
        }
        .onAppear {
            if let key = navigationBarMenuKey {
                navigationBarMenuManager.pop(key: key)
            }
            navigationBarMenuKey = navigationBarMenuManager.push([
                NavigationBarMenuItem(title: "View Profile") {
                    guard let recepient = inboxConversationViewModel.recepient else {
                        return
                    }
                    navigationManager.append(AppNavigation.userDetails(username: recepient))
                }
            ])
        }
        .onDisappear {
            guard let navigationBarMenuKey else { return }
            navigationBarMenuManager.pop(key: navigationBarMenuKey)
        }
        .showErrorUsingSnackbar(inboxConversationViewModel.$error)
    }
    
    private func sendMessage() {
        guard sendMessageTask == nil else {
            snackbarManager.showSnackbar(.info("A message is being sent"))
            return
        }
        
        sendMessageTask = Task {
            await inboxConversationViewModel.sendMessage(message: messageText)
            self.messageText = ""
            self.sendMessageTask = nil
        }
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
