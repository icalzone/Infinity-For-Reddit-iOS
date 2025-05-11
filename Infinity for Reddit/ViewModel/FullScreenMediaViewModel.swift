//
//  FullScreenMediaViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-04.
//

import Foundation

enum FullScreenMediaType {
    case image(url: String, aspectRatio: CGSize?, post: Post?)
    case gif(url: String, post: Post?)
    case video(url: String, post: Post?)
    case gallery(items: [GalleryItem], mediaMetadata: [String: MediaMetadata], galleryScrollState: GalleryScrollState)
}

class GalleryScrollState: ObservableObject {
    @Published var scrollId: Int = 0
    
    init(scrollId: Int) {
        self.scrollId = scrollId
    }
}

class FullScreenMediaViewModel: ObservableObject {
    @Published var media: FullScreenMediaType?
    @Published var currentId: String?
    
    func show(_ media: FullScreenMediaType) {
        self.media = media
        switch media {
        case .image(let url, _, _):
            self.currentId = url
        case .gif(let url, _):
            self.currentId = url
        case .video(let url, _):
            self.currentId = url
        default:
            self.currentId = nil
        }
    }
    
    func dismiss() {
        self.media = nil
        self.currentId = nil
    }
}
