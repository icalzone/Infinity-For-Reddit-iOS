//
//  PostModerationRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-24.
//

protocol PostModerationRepositoryProtocol {
    func approvePost(post: Post) async throws
    func removePost(post: Post, isSpam: Bool) async throws
    func toggleSticky(post: Post) async throws
    func toggleLock(post: Post) async throws
    func toggleSensitive(post: Post) async throws
    func toggleSpoiler(post: Post) async throws
    func toggleDistinguishAsMod(post: Post) async throws
}
