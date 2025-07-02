//
//  OtherSortTypeKindSource.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-01.
//

enum OtherSortTypeKindSource: SortTypeKindSource {
    case postDetails
    case commentListing
    case subredditListing
    case userListing
    
    var availableSortTypes: [SortType.Kind] {
        return [.best, .top, .new, .controversial, .old, .random, .qa, .live]
    }
}
