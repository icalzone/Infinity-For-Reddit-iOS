//
// Rule.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-24
        
import GRDB

public struct Rule: Codable, FetchableRecord, PersistableRecord, Identifiable {
    public static let databaseTableName = "rules"
    
    let shortName: String
    let description: String
    
    public var id: String {
        return self.shortName
    }
    
    init(shortName: String, description: String) {
        self.shortName = shortName
        self.description = description
    }
}
