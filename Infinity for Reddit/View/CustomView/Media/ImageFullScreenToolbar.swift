//
//  ImageFullScreenToolbar.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-24.
//

import SwiftUI

struct ImageFullScreenToolbar: View {
    let onDownload: () -> Void
    let onSetAsWallpaper: () -> Void
    let onShare: () -> Void
    
    private let buttonSize: CGFloat = 24
    
    var body: some View {
        HStack {
            Button {
                onDownload()
            } label: {
                SwiftUI.Image(systemName: "square.and.arrow.down")
                    .font(.system(size: buttonSize))
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
                    .padding(.bottom, 10)
                    .background(
                        Circle()
                            .fill(Color.red)
                    )
            }
            
            Button {
                onSetAsWallpaper()
            } label: {
                SwiftUI.Image(systemName: "photo.on.rectangle")
                    .font(.system(size: buttonSize - 4))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.red)
                    )
            }
            
            Button {
                onShare()
            } label: {
                SwiftUI.Image(systemName: "square.and.arrow.up")
                    .font(.system(size: buttonSize))
                    .padding(.horizontal, 8)
                    .padding(.top, 6)
                    .padding(.bottom, 10)
                    .background(
                        Circle()
                            .fill(Color.red)
                    )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.gray.opacity(0.4))
        )
        .padding(.bottom, 64)
    }
}
