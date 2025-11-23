//
//  CopyCustomFeedRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

protocol CopyCustomFeedRepositoryProtocol {
    func fetchCustomFeedDetails(path: String) async throws -> CustomFeed
}
