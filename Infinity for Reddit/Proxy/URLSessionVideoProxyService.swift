//
//  URLSessionVideoProxyService.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-11-25.
//

import Combine
import Foundation

struct VideoProxyResponseItem {
    let data: Data
    let mimeType: String?
    let statusCode: Int
    let headers: [String: String]
}

final class URLSessionVideoProxyService: VideoProxyService {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func dataTaskPublisher(_ request: URLRequest) -> AnyPublisher<VideoProxyResponseItem, Error> {
        guard let url = request.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        print("VideoProxy: Fetching via URLSession:", url.absoluteString)

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                var headerFields = [String: String]()
                httpResponse.allHeaderFields.forEach { key, value in
                    if let key = key as? String,
                       let value = value as? String {
                        headerFields[key] = value
                    }
                }

                print("VideoProxy: Received response: \(httpResponse.statusCode) - \(data.count) bytes")

                return VideoProxyResponseItem(
                    data: data,
                    mimeType: httpResponse.mimeType,
                    statusCode: httpResponse.statusCode,
                    headers: headerFields
                )
            }
            .eraseToAnyPublisher()
    }
}
