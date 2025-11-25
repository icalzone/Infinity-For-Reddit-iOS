//
//  PostModerationRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-24.
//

import Alamofire

class PostModerationRepository: PostModerationRepositoryProtocol {
    private let session: Session
    
    init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session in PostModerationRepository")
        }
        self.session = resolvedSession
    }
    
    func approvePost(post: Post) async throws {
        let params = ["id": post.name]
        _ = try await self.session.request(RedditOAuthAPI.approveThing(params: params))
            .validate()
            .serializingData()
            .value
    }
    
    func removePost(post: Post, isSpam: Bool) async throws {
        let params = ["id": post.name, "spam": isSpam ? "true" : "false"]
        _ = try await self.session.request(RedditOAuthAPI.removeThing(params: params))
            .validate()
            .serializingData()
            .value
    }
    
    func toggleSticky(post: Post) async throws {
        let params = ["id": post.name, "state": post.stickied ? "false" : "true", "api_type": "json"]
        _ = try await self.session.request(RedditOAuthAPI.toggleStickyPost(params: params))
            .validate()
            .serializingData()
            .value
    }
    
    func toggleLock(post: Post) async throws {
        let params = ["id": post.name]
        _ = try await self.session.request(post.locked ? RedditOAuthAPI.unlockThing(params: params) : RedditOAuthAPI.lockThing(params: params))
            .validate()
            .serializingData()
            .value
    }
    
    func toggleSensitive(post: Post) async throws {
        let params = ["id": post.name]
        _ = try await self.session.request(post.over18 ? RedditOAuthAPI.unmarkSensitive(params: params) : RedditOAuthAPI.markSensitive(params: params))
            .validate()
            .serializingData()
            .value
    }
    
    func toggleSpoiler(post: Post) async throws {
        let params = ["id": post.name]
        _ = try await self.session.request(post.spoiler ? RedditOAuthAPI.unmarkSpoiler(params: params) : RedditOAuthAPI.markSpoiler(params: params))
            .validate()
            .serializingData()
            .value
    }
    
    func toggleDistinguishAsMod(post: Post) async throws {
        let params = ["id": post.name, "how": post.isModerator ? "no" : "yes"]
        _ = try await self.session.request(RedditOAuthAPI.approveThing(params: params))
            .validate()
            .serializingData()
            .value
    }
}
