//
//  SubredditListingRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-19.
//

public protocol SubredditListingRepositoryProtocol {
    func fetchSubredditListing(queries: [String: String]) async throws -> SubredditListing
}
