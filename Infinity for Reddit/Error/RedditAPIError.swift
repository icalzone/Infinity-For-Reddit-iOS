//
//  RedditAPIError.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-13.
//

import Foundation

enum RedditAPIError: LocalizedError {
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .apiError(let message):
            return message
        }
    }
}
