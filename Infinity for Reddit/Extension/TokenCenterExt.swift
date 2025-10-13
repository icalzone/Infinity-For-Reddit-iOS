//
//  TokenCenter.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-13.
//

import Alamofire

extension TokenCenter {
    func getRedditPerAccountInterceptor(account: Account) -> RequestInterceptor {
        let username = account.username
        let provider = TokenCenter.shared
        return RedditPerAccountAccessTokenInterceptor(
            getToken: { await provider.currentAccessToken(for: username) },
            refreshToken: { try await provider.forceRefresh(for: username) }
        )
    }
}
