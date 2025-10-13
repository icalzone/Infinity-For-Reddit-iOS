//
//  SubmitPostRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-13.
//

protocol SubmitPostRepositoryProtocol {
    // Returns the ID of the submitted post
    func submitTextPost(
        account: Account,
        subredditName: String,
        title: String,
        content: String,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) async throws -> String
}
