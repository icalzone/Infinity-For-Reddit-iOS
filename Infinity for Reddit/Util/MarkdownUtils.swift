//
//  MarkdownUtils.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-28.
//

import Foundation

class MarkdownUtils {
    private static let REGEX_PATTERNS = {
        do {
            return try [
                NSRegularExpression(pattern: #"!?\[gif\]\(([^)]+)\)"#, options: [])
            ]
        } catch {
            fatalError("Error creating regular expressions: \(error)")
        }
    }()
    
    static func modifyCommentBody(_ comment: Comment) -> String{
        var body: String
        body = replaceGifURL(comment)
        
        return body
    }
    
    static func replaceGifURL(_ comment: Comment) -> String {
        guard let commentBody = comment.body else {
            return "Comment body not found" // Handle the case where commentBody is nil
        }
        var replacedBody = commentBody
        
        
        let gifMatches = REGEX_PATTERNS[0].matches(in: commentBody, options: [], range: NSRange(location: 0, length: commentBody.count))
        guard !gifMatches.isEmpty else {
            return commentBody // No Markdown gif found
        }
        
        for match in gifMatches {
            let rangeOfFirstGroup = Range(match.range(at: 1), in: commentBody)!
            let matchedString = String(commentBody[rangeOfFirstGroup])
            print("matched \(matchedString)")
            guard let mediaMetadata = comment.mediaMetadata,
                  let mediaData = mediaMetadata[matchedString] as? [String: Any],
                  let sData = mediaData["s"] as? [String: Any],
                  let gifURL = sData["gif"] as? String else {
                continue
            }
            replacedBody = replacedBody.replacingOccurrences(of: matchedString, with: gifURL)
        }
        
        return replacedBody
    }
}


