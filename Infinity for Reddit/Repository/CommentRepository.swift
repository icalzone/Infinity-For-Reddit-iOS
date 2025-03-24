//
//  CommentRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-03-24.
//

import Combine
import Alamofire
import SwiftyJSON
import Foundation

public class CommentRepository: CommentRepositoryProtocol {
    enum CommentRepositoryError: Error {
        case NetworkError(String)
        case JSONDecodingError(String)
    }
    
    private let session: Session
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        self.session = resolvedSession
    }
    
    public func voteComment(
        comment: Comment,
        point: String
    ) -> AnyPublisher<Void, any Error> {
        let params = ["dir": point, "id": comment.name!, "rank": "10"]
        
        return Future<Void, any Error> { promise in
            self.session.request(RedditOAuthAPI.vote(params: params))
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        promise(.success(Void()))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
