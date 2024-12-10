//
//  PostViewCard.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-08.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostViewCard: View {
    @EnvironmentObject var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(post.subredditNamePrefixed)
                        //.frame(maxWidth: .infinity, alignment: .leading)
                    Text("u/\(post.author)")
                }
                
                //Text(Date(timeIntervalSince1970: TimeInterval(post.createdUtc)))
            }
            .padding(.vertical, 8)
            
            Text(post.title)
            
            if let preview = post.preview, preview.images.count > 0, let url = preview.images[0].source.url {
                WebImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .aspectRatio(preview.images[0].source.aspectRatio, contentMode: .fit)
                }  placeholder: {
                    Rectangle().foregroundColor(.gray)
                }
                .onSuccess { image, data, cacheType in
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .aspectRatio(preview.images[0].source.aspectRatio, contentMode: .fit)
            } else if let selftextTruncated = post.selftextTruncated {
                Text(selftextTruncated)
            }
            
            HStack(alignment: .center) {
                Button {
                    
                } label: {
                    SwiftUI.Image("upvote")
                }
                
                Text(String(post.score))
                    .frame(width: 50, alignment: .center)
                
                Button {
                    
                } label: {
                    SwiftUI.Image("downvote")
                }
                .padding(.trailing, 16)
                
                Button {
                    
                } label: {
                    SwiftUI.Image("comment")
                }
                
                Text(String(post.numComments))
                
                Spacer()
                
                Button {
                    
                } label: {
                    SwiftUI.Image(systemName: "square.and.arrow.up")
                }
            }
            .padding(.vertical, 8)
        }
    }
}
