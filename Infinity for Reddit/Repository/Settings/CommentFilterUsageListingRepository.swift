//
//  CommentFilterUsageListingRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-06.
//

import GRDB

public class CommentFilterUsageListingRepository: CommentFilterUsageListingRepositoryProtocol {
    private let commentFilterUsageDao: CommentFilterUsageDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.commentFilterUsageDao = CommentFilterUsageDao(dbPool: resolvedDBPool)
    }
    
    public func saveCommentFilterUsage(_ commentFilterUsage: CommentFilterUsage) -> Bool {
        do {
            try commentFilterUsageDao.insert(commentFilterUsage: commentFilterUsage)
            return true
        } catch {
            print("Save comment filter usage failed with error: \(error)")
            return false
        }
    }
    
    public func deleteCommentFilterUsage(_ commentFilterUsage: CommentFilterUsage) -> Bool {
        do {
            try commentFilterUsageDao.deleteCommentFilterUsage(commentFilterUsage: commentFilterUsage)
            return true
        } catch {
            print("Delete comment filter usage failed with error: \(error)")
            return false
        }
    }
}
