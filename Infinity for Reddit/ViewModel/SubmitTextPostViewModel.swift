//
// SubmitTextPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21

import Foundation
import MarkdownUI

@MainActor
class SubmitTextPostViewModel: ObservableObject {
    @Published var title: String = ""  
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var submitPostTask: Task<Void, Error>?
    @Published var submittedPostId: String?
    @Published var error: Error? = nil
    
    private let submitPostRepository: SubmitPostRepositoryProtocol
    
    init(submitPostRepository: SubmitPostRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.submitPostRepository = submitPostRepository
    }
    
    func submitPost(
        subredditName: String,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) {
        guard submitPostTask == nil else {
            return
        }
        
        submittedPostId = nil
        
        submitPostTask = Task {
            do {
                submittedPostId = try await submitPostRepository.submitTextPost(
                    account: selectedAccount,
                    subredditName: subredditName,
                    title: title, content: content,
                    flair: flair,
                    isSpoiler: isSpoiler,
                    isSensitive: isSensitive,
                    receivePostReplyNotifications: receivePostReplyNotifications,
                    isRichTextJSON: isRichTextJSON
                )
            } catch {
                self.error = error
                print(error)
            }
            
            self.submitPostTask = nil
        }
    }
}
