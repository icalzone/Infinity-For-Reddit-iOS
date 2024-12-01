//
//  RedditGRDBDatabase.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-11-30.
//

import Foundation
import GRDB

struct RedditGRDBDatabase {
    public static func create() throws -> DatabasePool {
        let path = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("reddit_data.sqlite")
            .path
        
        let dbPool = try DatabasePool(path: path)
        try setupMigrations(dbPool)
        return dbPool
    }
    
    private static func setupMigrations(_ dbPool: DatabasePool) throws {
        // TODO for future database scheme migration
    }
}
