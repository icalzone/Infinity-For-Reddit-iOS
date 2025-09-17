//
//  FlairRichTextView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-17.
//

import SwiftUI

struct FlairRichTextView: View {
    let flairRichtext: [FlairRichtext]
    var usePrimaryTextColor: Bool = false
    let emojiSize: CGFloat = 14
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(flairRichtext, id: \.self) { part in
                if part.e == "text", let text = part.t {
                    Text(text)
                        .applyIf(usePrimaryTextColor) {
                            $0.primaryText()
                        }
                        .applyIf(!usePrimaryTextColor) {
                            $0.postFlairText()
                        }
                } else if part.e == "emoji", let url = part.u, let imageURL = URL(string: url) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: emojiSize, height: emojiSize)
                        default:
                            Color.clear
                                .frame(width: emojiSize, height: emojiSize)
                        }
                    }
                    .baselineOffset(-2) // Align with text
                } else {
                    // Unknown flair type
                    EmptyView()
                }
            }
        }
    }
}
