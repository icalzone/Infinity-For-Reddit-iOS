//
//  JSON.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-13.
//

import SwiftyJSON

extension JSON {
    func throwIfRedditError(defaultErrorMessage: String) throws {
        let errorArray = self["json"]["errors"].arrayValue
        guard !errorArray.isEmpty else { return }
        
        if let lastErrorArray = errorArray.last?.array, !lastErrorArray.isEmpty {
            let errorString: String
            if lastErrorArray.count >= 2 {
                errorString = lastErrorArray[1].stringValue
            } else {
                errorString = lastErrorArray[0].stringValue
            }
            throw(RedditAPIError.apiError(errorString.prefix(1).uppercased() + errorString.dropFirst()))
        } else {
            throw(RedditAPIError.apiError(defaultErrorMessage))
        }
    }
}
