//
//  PostListingType.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-05.
//

import Alamofire

public struct PostListingMetadata: Hashable {
    var postListingType: PostListingType
    var pathComponents: [String: String]
    var headers: HTTPHeaders?
    var queries: [String: String]?
    var params: [String: String]?
    
    init(postListingType: PostListingType,
         pathComponents: [String: String] = [:],
         headers: HTTPHeaders? = nil,
         queries: [String: String]? = nil,
         params: [String: String]? = nil
    ) {
        self.postListingType = postListingType
        self.pathComponents = pathComponents
        self.headers = headers
        self.queries = queries
        self.params = pathComponents
    }
    
    static func getSubredditMetadadata(subredditName: String, accountViewModel: AccountViewModel) -> PostListingMetadata {
        return PostListingMetadata(
            postListingType:.subreddit(subredditName: subredditName),
            pathComponents: ["subreddit": subredditName],
            headers: APIUtils.getOAuthHeader(accessToken: accountViewModel.account.accessToken ?? ""),
            queries: nil,
            params: nil
        )
    }
    
    func getPostFeedID() -> String {
        switch postListingType {
        case .frontPage:
            return "best_post"
            
        case .anonymousFrontPage(let concatenatedSubscriptions):
            if let subs = concatenatedSubscriptions, !subs.isEmpty {
                return "best_post_\(subs)"
            }
            return "best_post_anonymous"
            
        case .subreddit(let subredditName):
            return "r_\(subredditName.lowercased())"
            
        case .user(let username, let userWhere):
            return "u_\(username.lowercased())_\(userWhere.rawValue)"
            
        case .customFeed(let path):
            return "m_\(path.lowercased())"
            
        case .search(let query, let searchInSubredditOrUserName, let searchInMultiReddit, _):
            if let sr = searchInSubredditOrUserName {
                return "search_\(sr.lowercased())_\(query.lowercased())"
            } else if let multi = searchInMultiReddit {
                return "search_m_\(multi.lowercased())_\(query.lowercased())"
            } else {
                return "search_\(query.lowercased())"
            }
        }
    }
}

public enum PostListingType: Codable, Hashable {
    case frontPage
    case subreddit(subredditName: String)
    case user(username: String, userWhere: UserWhere)
    case search(query: String, searchInSubredditOrUserName: String?, searchInMultiReddit: String?, searchInThingType: SearchInThingType)
    case customFeed(path: String)
    case anonymousFrontPage(concatenatedSubscriptions: String?)
}

public enum UserWhere: String, Codable {
    case submitted = "submitted", upvoted = "upvoted", downvoted = "downvoted", hidden = "hidden", saved = "saved"
}

enum SortEmbeddingStyle {
    case inPath
    case inQuery(key: String)
    case none
}
