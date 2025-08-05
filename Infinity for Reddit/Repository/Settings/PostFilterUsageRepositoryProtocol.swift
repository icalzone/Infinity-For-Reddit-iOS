//
//  PostFilterUsageRepositoryProtocol.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-03.
//

public protocol PostFilterUsageRepositoryProtocol {
    func savePostFilterUsage(_ postFilterUsage: PostFilterUsage) -> Bool
    func deletePostFilterUsage(_ postFilterUsage: PostFilterUsage) -> Bool
}
