//
//  SearchRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

import Foundation

class SearchRepository: SearchRepositoryProtocol {
    private let recentSearchQueryDao: RecentSearchQueryDao
    
    init(recentSearchQueryDao: RecentSearchQueryDao) {
        self.recentSearchQueryDao = recentSearchQueryDao
    }
    
    func saveSearchQuery(username: String,
                         query: String,
                         searchInSubredditOrUserName: String?,
                         customFeedPath: String?,
                         customFeedDisplayName: String?,
                         searchInThingType: SearchInThingType,
                         time: Int64
    ) async {
        do {
            try await self.recentSearchQueryDao.insert(
                recentSearchQuery:
                    RecentSearchQuery(
                        username: username,
                        searchQuery: query,
                        searchInSubredditOrUserName: searchInSubredditOrUserName,
                        customFeedPath: customFeedPath,
                        customFeedDisplayName: customFeedDisplayName,
                        searchInThingType: searchInThingType,
                        time: time
                    )
            )
        } catch {
            // No need to handle error
            printInDebugOnly(error)
        }
    }
    
    func clearAllRecentSearchQueries(username: String) async {
        do {
            try await self.recentSearchQueryDao.deleteAllRecentSearchQueries(username: username)
        } catch {
            // No need to handle error
            printInDebugOnly(error)
        }
    }
    
    func deleteRecentSearchQueries(recentSearchQuery: RecentSearchQuery) async {
        do {
            try await self.recentSearchQueryDao.deleteRecentSearchQuery(recentSearchQuery: recentSearchQuery)
        } catch {
            // No need to handle error
            printInDebugOnly(error)
        }
    }
}
