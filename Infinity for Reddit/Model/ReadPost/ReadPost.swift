//
// ReadPost.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-03
//

import GRDB

struct ReadPost: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "read_posts"
    
    var username: String
    var id: String
    var time: Int64?
    
    init(username: String, id: String, time: Int64? = nil) {
        self.username = username
        self.id = id
        self.time = time
    }
}
