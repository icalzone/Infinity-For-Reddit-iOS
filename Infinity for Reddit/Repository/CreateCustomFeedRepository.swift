//
//  CreateCustomFeedRepository.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import Alamofire
import IdentifiedCollections
import SwiftyJSON
import Foundation
import GRDB

class CreateCustomFeedRepository: CreateCustomFeedRepositoryProtocol {
    enum CreateCustomFeedRepositoryError: LocalizedError {
        case failedToCreateCustomFeedModel
        
        var errorDescription: String? {
            switch self {
            case .failedToCreateCustomFeedModel:
                return "Failed to create a model of the custom feed"
            }
        }
    }
    
    private let session: Session
    private let myCustomFeedDao: MyCustomFeedDao
    
    public init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session in SendChatMessageRepository")
        }
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError( "Failed to resolve DatabasePool")
        }
        self.session = resolvedSession
        self.myCustomFeedDao = MyCustomFeedDao(dbPool: resolvedDBPool)
    }
    
    func createCustomFeed(name: String, description: String, isPrivate: Bool, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<SubredditAndUserInCustomFeed>) async throws -> CustomFeed {
//        guard !AccountViewModel.shared.account.isAnonymous() else {
//            try await createCustomFeedAnonymous(name: name, description: description, subredditsAndUsersInCustomFeed: subredditsAndUsersInCustomFeed)
//            return
//        }
//        let json = JSON([
//            "display_name": name,
//            "description_md": description,
//            "visibility": isPrivate ? "private" : "public",
//            "subreddits": subredditsAndUsersInCustomFeed.map {
//                ["name": $0.name]
//            }
//        ])
        
        let payload = CustomFeedModelPayload(
            name: name, description: description, visibility: isPrivate ? "private" : "public", subreddits: subredditsAndUsersInCustomFeed.map {
                ["name": $0.name]
            }
        )
        let model = try JSONEncoder().encode(payload)

        if let modelString = String(data: model, encoding: .utf8) {
            print(modelString)
            
            let multipathName: String
            if let spaceIndex = name.firstIndex(of: " ") {
                multipathName = String(name[..<spaceIndex])
            } else {
                multipathName = name
            }
            
            let params: [String: String] = [
                "multipath": "/user/\(AccountViewModel.shared.account.username)/m/\(multipathName)",
                "model": String(format: modelString)
            ]
            
            print(params)
            
            let response = await self.session.request(RedditOAuthAPI.createCustomFeed(params: params))
                .serializingData(automaticallyCancelling: true)
                .response
            
            guard let statusCode = response.response?.statusCode, let data = response.data else {
                throw APIError.networkError("Cannot create this custom feed.")
            }

            if (200...299).contains(statusCode) {
                let json = JSON(data)
                if let error = json.error {
                    throw APIError.jsonDecodingError(error.localizedDescription)
                }
                
                return try CustomFeed(fromJson: json["data"])
            } else {
                if let customFeedCreationError = try? CustomFeedCreationError(fromJson: JSON(data)) {
                    throw APIError.invalidResponse(customFeedCreationError.explanation.capitalizedFirst)
                } else {
                    throw APIError.networkError("Cannot create this custom feed.")
                }
            }
        } else {
            throw CreateCustomFeedRepositoryError.failedToCreateCustomFeedModel
        }
    }
    
//    func createCustomFeedAnonymous(name: String, description: String, subredditsAndUsersInCustomFeed: IdentifiedArrayOf<SubredditAndUserInCustomFeed>) async throws -> MyCustomFeed {
//        
//    }
    
    func saveMyCustomFeed(_ myustomFeed: MyCustomFeed) async throws {
        try myCustomFeedDao.insert(myCustomFeed: myustomFeed)
    }
    
    private struct CustomFeedModelPayload: Codable {
        var name: String
        var description: String
        var visibility: String
        var subreddits: [[String: String]]
        
        enum CodingKeys: String, CodingKey {
            case name = "display_name"
            case description = "description_md"
            case visibility
            case subreddits = "subreddits"
        }
    }
    
    class CustomFeedCreationError {
        var explanation : String!
        var fields : [String]!
        var message : String!
        var reason : String!

        init(fromJson json: JSON!) throws {
            if json.isEmpty {
                throw JSONError.invalidData
            }
            explanation = json["explanation"].stringValue
            fields = [String]()
            let fieldsArray = json["fields"].arrayValue
            for fieldsJson in fieldsArray{
                fields.append(fieldsJson.stringValue)
            }
            message = json["message"].stringValue
            reason = json["reason"].stringValue
        }
    }
}
