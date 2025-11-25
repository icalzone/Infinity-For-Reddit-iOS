//
//  ThingModerationRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-24.
//

protocol ThingModerationRepositoryProtocol {
    func approveThing(thingFullname: String) async throws
    func removeThing(thingFullname: String, isSpam: Bool) async throws
    func toggleSticky(post: Post) async throws
    func toggleLock(thingFullname: String, lock: Bool) async throws
    func toggleSensitive(post: Post) async throws
    func toggleSpoiler(post: Post) async throws
    func toggleDistinguishAsMod(post: Post) async throws
}
