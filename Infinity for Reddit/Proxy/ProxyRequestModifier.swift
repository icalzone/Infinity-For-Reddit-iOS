//
//  ProxyRequestModifier.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-11-26.
//

import Foundation
import Kingfisher

struct ProxyRequestModifier: ImageDownloadRequestModifier {
    func modified(for request: URLRequest) -> URLRequest? {
        guard let url = request.url else {
            return request
        }
        var nextRequest = request
        let ext = url.pathExtension.lowercased()
        print("Kingfisher proxy format:", ext.isEmpty ? "None" : ext, url.absoluteString)
        nextRequest.url = ProxyManager.shared.proxyURL(url)
        return nextRequest
    }
}
