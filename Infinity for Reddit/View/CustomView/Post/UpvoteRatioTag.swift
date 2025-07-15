//
//  UpvoteRatioTag.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-15.
//

import SwiftUI

struct UpvoteRatioTag: View {
    let post: Post
    
    var body: some View {
        HStack(spacing: 4) {
            SwiftUI.Image(systemName: "hand.thumbsup.circle.fill")
                .upvoteRatioIcon()
            
            Text("\(Int(post.upvoteRatio * 100))%")
                .upvoteRatioText()
        }
    }
}
