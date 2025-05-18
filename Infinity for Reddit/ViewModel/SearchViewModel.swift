//
//  SearchViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-05-18.
//

import Foundation
import Combine
import GRDB

class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var recentSearchQueries: [RecentSearchQuery] = []
    
    private let dbPool: DatabasePool
    
    private let recentSearchQueriesPublisher: AnyPublisher<[RecentSearchQuery], Error>
    
    private let operationqueue: OperationQueue
    private var cancellables = Set<AnyCancellable>()
    
    init(username: String) {
        guard let resolvedOperationQueue = DependencyManager.shared.container.resolve(OperationQueue.self) else {
            fatalError("Could not resolve OperationQueue")
        }
        
        guard let resolvedDatabasePool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Could not resolve DatabasePool")
        }
        
        self.operationqueue = resolvedOperationQueue
        self.dbPool = resolvedDatabasePool
        
        let recentSearchQueryDao = RecentSearchQueryDao(dbPool: dbPool)
        recentSearchQueriesPublisher = recentSearchQueryDao.getAllRecentSearchQueriesLiveData(username: username)
        
        receiveRecentSearchQueries()
    }
    
    private func receiveRecentSearchQueries() {
        recentSearchQueriesPublisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished successfully.")
                case .failure(let error):
                    print("Encountered an error: \(error)")
                }
            },
            receiveValue: { result in
                self.recentSearchQueries = result
            }
        )
        .store(in: &cancellables)
    }
}
