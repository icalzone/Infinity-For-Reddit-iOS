//
//  PostFilterUsageViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-03.
//

import Foundation
import GRDB
import Combine

class PostFilterUsageViewModel: ObservableObject {
    @Published var postFilterUsages: [PostFilterUsage] = []
    
    private let postFilterId: Int
    private let postFilterUsageRepository: PostFilterUsageRepositoryProtocol
    private let postFilterUsageDao: PostFilterUsageDao
    
    private var listener: AnyDatabaseCancellable?
    
    private let postFilterUsagesPublisher: AnyPublisher<[PostFilterUsage], Error>
    
    private var cancellables = Set<AnyCancellable>()
    
    init(postFilterId: Int, postFilterUsageRepository: PostFilterUsageRepositoryProtocol) {
        guard let resolvedDBPool = DependencyManager.shared.container.resolve(DatabasePool.self) else {
            fatalError("Failed to resolve DatabasePool")
        }
        self.postFilterId = postFilterId
        self.postFilterUsageRepository = postFilterUsageRepository
        self.postFilterUsageDao = PostFilterUsageDao(dbPool: resolvedDBPool)
        self.postFilterUsagesPublisher = postFilterUsageDao.getAllPostFilterUsageLiveData(postFilterId: postFilterId)
        
        postFilterUsagesPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] postFilterUsages in
                self?.postFilterUsages = postFilterUsages
            })
            .store(in: &cancellables)
    }
    
    func savePostFilterUsage(usageType: PostFilterUsage.UsageType, nameOfUsage: String?) {
        let postFilterUsage = PostFilterUsage(postFilterId: postFilterId, usageType: usageType, nameOfUsage: nameOfUsage)
        if !postFilterUsageRepository.savePostFilterUsage(postFilterUsage) {
            // TODO handle error
        }
    }
    
    func deletePostFilterUsage(_ postFilterUsage: PostFilterUsage) {
        if !postFilterUsageRepository.deletePostFilterUsage(postFilterUsage) {
            // TODO handle error
        }
    }
}
