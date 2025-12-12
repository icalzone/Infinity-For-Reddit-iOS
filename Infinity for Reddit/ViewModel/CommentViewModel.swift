//
//  CommentViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-17.
//  

import Foundation
import Alamofire
import Combine

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comment: Comment
    
    private var cancellables = Set<AnyCancellable>()
    
    init(comment: Comment) {
        self.comment = comment
        comment.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
