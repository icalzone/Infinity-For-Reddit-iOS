//
//  CommentIndentationView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-03.
//

import SwiftUI

struct CommentIndentationView: View {
    let depth: Int
    
    var body: some View {
        if depth > 0 {
            HStack(spacing: 8) {
                ForEach(0..<depth, id:\.self) { depth in
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 2)
                }
            }
            .padding(.leading, 12)
        }
    }
}
