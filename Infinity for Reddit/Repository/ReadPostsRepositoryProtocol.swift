//
//  ReadPostsRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-10.
//

protocol ReadPostsRepositoryProtocol {
    func getReadPostsIdsByIds(readPostEnabled: Bool, account: Account, postIds: [String]) -> Set<String>
}
