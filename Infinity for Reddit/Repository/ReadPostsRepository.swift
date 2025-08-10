//
//  ReadPostsRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-10.
//

import GRDB

class ReadPostsRepository: ReadPostsRepositoryProtocol {
    private let readPostDao: ReadPostDao
    
    init() {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        do {
            let readPostCount = try resolvedDBPool.read { db in
                print(try ReadPost.fetchAll(db, sql: "SELECT * FROM read_posts") ?? [])
            }
        } catch {
            print("fuck you")
        }
        
        self.readPostDao = ReadPostDao(dbPool: resolvedDBPool)
    }
    
    func getReadPostsIdsByIds(readPostEnabled: Bool, account: Account, postIds: [String]) -> Set<String> {
        guard !account.isAnonymous() else {
            return Set<String>()
        }
        
        do {
            return readPostEnabled ? Set(try readPostDao.getReadPostsIdsByIds(ids: postIds, username: account.username)) : Set<String>()
        } catch {
            print("getReadPostsIdsByIds failed with error: \(error)")
            return Set<String>()
        }
    }
}
