//
//  FilteredPostsViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-02.
//

import Foundation

class FilteredPostsViewModel: ObservableObject {
    @Published var postFilter: PostFilter
    
    init(postFilter: PostFilter) {
        self.postFilter = postFilter
    }
}
