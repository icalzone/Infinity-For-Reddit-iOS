//
// ReadPost.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-03
//

import GRDB

struct ReadPost: Codable, FetchableRecord, PersistableRecord, Equatable, Hashable {
    static let databaseTableName = "read_posts"
    
    let username: String
    let postId: String
    var time: Int64
    
    init(username: String, postId: String, time: Int64) {
        self.username = username
        self.postId = postId
        self.time = time
    }
    
    private enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case username
        case postId = "post_id"
        case time
    }
    
    enum Columns {
        static let username = Column(CodingKeys.username)
        static let postId = Column(CodingKeys.postId)
        static let time = Column(CodingKeys.time)
    }

    public static let databaseSelection: [SQLSelectable] = CodingKeys.allCases.map { $0 }
    
    // Equatable conformance
    static func == (lhs: ReadPost, rhs: ReadPost) -> Bool {
        return lhs.username == rhs.username && lhs.postId == rhs.postId
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(postId)
    }
}
