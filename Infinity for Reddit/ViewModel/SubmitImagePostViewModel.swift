//
// SubmitImagePostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-24
        
import Foundation
import MarkdownUI
import SwiftUI

@MainActor
class SubmitImagePostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var capturedImage: UIImage? = nil
    @Published var submitPostTask: Task<Void, Error>?
    @Published var postSubmittedFlag: Bool = false
    @Published var error: Error? = nil
    
    private let submitPostRepository: SubmitPostRepositoryProtocol
    private let mediaUploadRepository: MediaUploadRepositoryProtocol
    
    enum SubmitImagePostViewModelError: LocalizedError {
        case imageNotSelectedError
        
        var errorDescription: String? {
            switch self {
            case .imageNotSelectedError:
                return "Please select an image first."
            }
        }
    }
    
    init(submitPostRepository: SubmitPostRepositoryProtocol, mediaUploadRepository: MediaUploadRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.submitPostRepository = submitPostRepository
        self.mediaUploadRepository = mediaUploadRepository
    }
    
    func setCapturedImage(_ image: UIImage) {
        capturedImage = image
        print("Updated captured image: \(image.description)")
    }
    
    func clearCapturedImage() {
        capturedImage = nil
        print("Cleared captured image")
    }
    
    func submitPost(
        subreddit: SubscribedSubredditData?,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) {
        guard submitPostTask == nil else {
            return
        }
        
        guard let subreddit = subreddit, !subreddit.name.isEmpty else {
            error = PostSubmissionError.subredditNotSelectedError
            return
        }
        
        guard !title.isEmpty else {
            error = PostSubmissionError.noTitleError
            return
        }
        
        guard let capturedImage = capturedImage else {
            error = SubmitImagePostViewModelError.imageNotSelectedError
            return
        }
        
        postSubmittedFlag = false
        
        submitPostTask = Task {
            do {
                let imageUrlString = try await mediaUploadRepository.uploadImage(account: selectedAccount, image: capturedImage)
                
                try await submitPostRepository.submitImagePost(
                    account: selectedAccount,
                    subredditName: subreddit.name,
                    title: title,
                    content: content,
                    imageUrlString: imageUrlString,
                    flair: flair,
                    isSpoiler: isSpoiler,
                    isSensitive: isSensitive,
                    receivePostReplyNotifications: receivePostReplyNotifications,
                    isRichTextJSON: isRichTextJSON
                )
                
                postSubmittedFlag = true
            } catch {
                self.error = error
                print(error)
            }
            
            self.submitPostTask = nil
        }
    }
}

