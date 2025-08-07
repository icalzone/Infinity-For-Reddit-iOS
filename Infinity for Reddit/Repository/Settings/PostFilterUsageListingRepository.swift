//
//  PostFilterUsageRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-03.
//

import GRDB

public class PostFilterUsageListingRepository: PostFilterUsageListingRepositoryProtocol {
    private let postFilterUsageDao: PostFilterUsageDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.postFilterUsageDao = PostFilterUsageDao(dbPool: resolvedDBPool)
    }
    
    public func savePostFilterUsage(_ postFilterUsage: PostFilterUsage) -> Bool {
        do {
            try postFilterUsageDao.insert(postFilterUsage: postFilterUsage)
            return true
        } catch {
            print("Save post filter usage failed with error: \(error)")
            return false
        }
    }
    
    public func deletePostFilterUsage(_ postFilterUsage: PostFilterUsage) -> Bool {
        do {
            try postFilterUsageDao.deletePostFilterUsage(postFilterUsage: postFilterUsage)
            return true
        } catch {
            print("Delete post filter usage failed with error: \(error)")
            return false
        }
    }
}
