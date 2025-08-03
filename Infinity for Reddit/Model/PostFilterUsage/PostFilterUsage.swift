//
// PostFilterUsage.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2024-12-04
//

import GRDB

struct PostFilterUsage: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName = "post_filter_usage"
    static let HISTORY_TYPE_USAGE_READ_POSTS = "-read-posts"
    static let NO_USAGE = "--"
    
    enum UsageType: Int, Codable {
        case home = 1
        case subreddit = 2
        case user = 3
        case multireddit = 4
        case search = 5
        case history = 6
    }

    var name: String
    var usageType: UsageType
    var nameOfUsage: String

    init(name: String, usageType: UsageType, nameOfUsage: String? = nil) {
        self.name = name
        self.usageType = usageType
        self.nameOfUsage = nameOfUsage ?? PostFilterUsage.NO_USAGE
    }

    private enum CodingKeys: String, CodingKey, ColumnExpression {
        case name, usageType = "usage_type", nameOfUsage = "name_of_usage"
    }
}
