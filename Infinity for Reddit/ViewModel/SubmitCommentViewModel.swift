//
//  SubmitCommentViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-17.
//

import Foundation
import MarkdownUI
import SwiftUI

@MainActor
class SubmitCommentViewModel: ObservableObject {
    @Published var selectedAccount: Account
    @Published var text: String = ""
    @Published var embeddedImages: [UploadedImage] = []
    @Published var isSubmitting: Bool = false
    @Published var error: Error? = nil
    
    let commentParent: CommentParent
    
    private let submitCommentRepository: SubmitCommentRepositoryProtocol
    private let mediaUploadRepository: MediaUploadRepositoryProtocol
    
    init(commentParent: CommentParent,
         submitCommentRepository: SubmitCommentRepositoryProtocol,
         mediaUploadRepository: MediaUploadRepositoryProtocol
    ) {
        self.selectedAccount = AccountViewModel.shared.account
        self.commentParent = commentParent
        self.submitCommentRepository = submitCommentRepository
        self.mediaUploadRepository = mediaUploadRepository
    }
    
    func submitComment() async -> Comment? {
        guard isSubmitting == false else { return nil }
        
        isSubmitting = true
        
        var sentComment: Comment? = nil
        do {
            sentComment = try await submitCommentRepository.submitComment(
                accout: selectedAccount,
                content: text,
                parentFullname: commentParent.parentFullname ?? "",
                depth: commentParent.childCommentDepth
            )
        } catch {
            self.error = error
            print("Error submitting comment: \(error)")
        }
        
        isSubmitting = false
        
        return sentComment
    }
    
    func addEmbeddedImage(_ image: UIImage) {
        let embeddedImage = UploadedImage(image: image) {
            try await self.mediaUploadRepository.uploadImage(account: self.selectedAccount, image: image, getImageId: true)
        }
        embeddedImage.upload()
        embeddedImages.append(embeddedImage)
    }
}
