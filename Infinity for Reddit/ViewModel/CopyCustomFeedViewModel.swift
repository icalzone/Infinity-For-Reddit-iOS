//
//  CopyCustomFeedViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-23.
//

import Foundation
import IdentifiedCollections

@MainActor
class CopyCustomFeedViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var subredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing> = []
    @Published var copyCustomFeedTask: Task<Void, Never>?
    @Published var copiedMyCustomFeed: MyCustomFeed?
    @Published var error: Error? = nil

    @Published var customFeedLoadState: LoadState = .idle
    
    private let path: String
    private let copyCustomFeedRepository: CopyCustomFeedRepositoryProtocol
    
    init(path: String, copyCustomFeedRepository: CopyCustomFeedRepositoryProtocol) {
        self.path = path
        self.copyCustomFeedRepository = copyCustomFeedRepository
    }
    
    func fetchCustomFeedDetailsToCopy() async {
        guard customFeedLoadState.canLoad else {
            return
        }

        customFeedLoadState = .loading
        
        do {
            let customFeed = try await copyCustomFeedRepository.fetchCustomFeedDetails(path: path)
            
            name = customFeed.name
            description = customFeed.descriptionMd
            for thingInCustomFeed in customFeed.subredditsInCustomFeed {
                subredditsAndUsersInCustomFeed.append(.subredditInCustomFeed(thingInCustomFeed))
            }
            
            customFeedLoadState = .loaded
        } catch {
            customFeedLoadState = .failed(error)
        }
    }
}
