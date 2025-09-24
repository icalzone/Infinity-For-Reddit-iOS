//
//  ImageFullScreenView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-03.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageFullScreenView: View {
    @EnvironmentObject var fullScreenMediaViewModel: FullScreenMediaViewModel
    @EnvironmentObject var namespaceManager: NamespaceManager
    
    let url: URL?
    let aspectRatio: CGSize?
    let matchedGeometryEffectId: String?
    let onDismiss: () -> Void
    
    init(url: URL?, aspectRatio: CGSize? = nil, matchedGeometryEffectId: String? = nil, onDismiss: @escaping () -> Void) {
        self.url = url
        self.aspectRatio = aspectRatio
        self.matchedGeometryEffectId = matchedGeometryEffectId
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            CustomWebImage(
                url?.absoluteString ?? "",
                aspectRatio: aspectRatio,
                handleImageTapGesture: false,
                matchedGeometryEffectId: matchedGeometryEffectId
            )
            .mediaGesture(
                outOfBoundsColor: .black,
                onDragEnded: { transform in
                    if transform.scaleX == 1 && transform.scaleY == 1 && abs(transform.ty) > 100 {
                        onDismiss()
                        return true
                    }
                    return false
                }
            )
            
            VStack {
                Spacer()
                
                ImageFullScreenToolbar(onDownload: {
                    print("download")
                }, onSetAsWallpaper: {
                    print("wallpaper")
                }, onShare: {
                    print("share")
                })
            }
        }
    }
}
