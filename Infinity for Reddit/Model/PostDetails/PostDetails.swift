//
//  PostDetails.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-23.
//

import Foundation
import SwiftyJSON
import MarkdownUI

public class PostDetailsRootClass: NSObject, Validatable {
    var postListing: PostListing!
    var commentListing: CommentListing!
    var comments: [CommentItem] = []

    init(fromJson json: JSON!, parseComments: Bool = true) throws {
        try Self.validate(json: json)
        
        if json.isEmpty {
            throw JSONError.invalidData
        }
        
        let postListingJson = json[0]
        if !postListingJson.isEmpty {
            postListing = try PostListingRootClass(fromJson: postListingJson).data
        }
        if parseComments {
            let commentListingJson = json[1]
            if !commentListingJson.isEmpty {
                commentListing = try CommentListingRootClass(fromJson: commentListingJson).data
            }
        }
    }
    
    func makeCommentList() {
        comments = []
        makeCommentList(commentListing: commentListing)
    }
    
    private func makeCommentList(commentListing: CommentListing) {
        guard !commentListing.comments.isEmpty else {
            if let commentMore = commentListing.commentMore {
                comments.append(CommentItem.more(commentMore))
            }
            return
        }
        
        for comment in commentListing.comments {
            guard let childrenCommentListing = comment.replies else {
                comments.append(CommentItem.comment(comment))
                continue
            }
            
            comments.append(CommentItem.comment(comment))
            // This is to make checking if a comment has replies available
            comment.commentMore = childrenCommentListing.commentMore
            makeCommentList(commentListing: childrenCommentListing)
        }
        
        if let commentMore = commentListing.commentMore {
            comments.append(CommentItem.more(commentMore))
        }
    }
}
