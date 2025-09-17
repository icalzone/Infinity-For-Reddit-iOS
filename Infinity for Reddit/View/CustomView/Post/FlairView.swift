//
//  FlairView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-07-15.
//

import SwiftUI

struct FlairView: View {
    let flairRichtext: [FlairRichtext]
    let flairText: String?
    let emojiSize: CGFloat = 14
    
    var body: some View {
        if flairRichtext.isEmpty {
            if let flairText = flairText, !flairText.isEmpty {
                Text(flairText)
                    .postFlairText()
                    .postFlairBackground()
            } else {
                EmptyView()
            }
        } else {
            FlairRichTextView(flairRichtext: flairRichtext)
                .postFlairBackground()
        }
    }
}
