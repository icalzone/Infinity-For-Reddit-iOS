//
//  VideoProxyService.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2025-11-25.
//

import Combine
import Foundation

protocol VideoProxyService {
    func dataTaskPublisher(_ request: URLRequest) -> AnyPublisher<VideoProxyResponseItem, Error>
}
