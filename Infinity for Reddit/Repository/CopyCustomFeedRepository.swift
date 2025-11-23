//
//  CopyCustomFeedRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import Alamofire
import GRDB
import SwiftyJSON

class CopyCustomFeedRepository: CopyCustomFeedRepositoryProtocol {
    private let session: Session
    private let myCustomFeedDao: MyCustomFeedDao
    private let anonymousCustomFeedSubredditDao: AnonymousCustomFeedSubredditDao
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session in CopyCustomFeedRepository")
        }
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError( "Failed to resolve DatabasePool in CopyCustomFeedRepository")
        }
        self.session = resolvedSession
        self.myCustomFeedDao = MyCustomFeedDao(dbPool: resolvedDBPool)
        self.anonymousCustomFeedSubredditDao = AnonymousCustomFeedSubredditDao(dbPool: resolvedDBPool)
    }
    
    func fetchCustomFeedDetails(path: String) async throws -> CustomFeed {
        let queries = ["multipath": path]
        
        try Task.checkCancellation()
        
        let data = try await self.session.request(RedditOAuthAPI.getCustomFeedInfo(queries: queries))
            .validate()
            .serializingData()
            .value
        
        let json = JSON(data)
        if let error = json.error {
            throw APIError.jsonDecodingError(error.localizedDescription)
        }
        
        return try CustomFeed(fromJson: json["data"])
    }
}
