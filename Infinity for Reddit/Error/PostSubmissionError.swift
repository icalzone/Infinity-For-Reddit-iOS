//
//  PostSubmissionError.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-14.
//

import Foundation

enum PostSubmissionError: LocalizedError {
    case subredditNotSelectedError
    case noTitleError
    
    var errorDescription: String? {
        switch self {
        case .subredditNotSelectedError:
            return "Please select a subreddit first."
        case .noTitleError:
            return "Title is required."
        }
    }
}
