//
//  PostTypeTag.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-15.
//

import SwiftUI

struct PostTypeTag: View {
    let post: Post
    
    var body: some View {
        Text(post.postType.text)
            .postTypeTag()
    }
}
