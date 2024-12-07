//
//  PostListingViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-05.
//

import Foundation
import Combine

public class PostListingViewModel: ObservableObject {
    // MARK: - Properties
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    private var isInitialLoad: Bool = true
    
    private var allPostIds = Set<String>()
    private var after: String? = nil
    private let pageSize: Int = 100
    private var cancellables = Set<AnyCancellable>()
    
    public let postListingRepository: PostListingRepositoryProtocol
    
    // MARK: - Initializer
    init(postListingRepository: PostListingRepositoryProtocol) {
        self.postListingRepository = postListingRepository
    }
    
    // MARK: - Methods
    
    /// Fetches the next page of posts
    public func loadPosts(account: Account) {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        if isInitialLoad {
            postListingRepository.setAccount(account)
            isInitialLoad = false
        }
        
        postListingRepository.fetchPosts(postListingType: .frontPage, limit: 100)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching posts: \(error)")
                }
            }, receiveValue: { [weak self] listingData in
                guard let self = self else { return }
                //self.posts.append(contentsOf: newPosts)
                if (listingData.posts.isEmpty) {
                    // No more posts
                } else {
                    let realNewPosts = listingData.posts.filter {
                        !self.allPostIds.contains($0.id)
                    }
                    
                    self.posts.append(contentsOf: realNewPosts)
                    
                    allPostIds.formUnion(
                        realNewPosts
                            .compactMap {
                                $0.id
                            }
                    )
                }
                print("fuck")
            })
            .store(in: &cancellables)
    }
    
    /// Reloads posts from the first page
    func refreshPosts(account: Account) {
        // This is for user switching accounts. We have to force clear all load
        cancellables.forEach { $0.cancel() }
        
        isInitialLoad = true
        isLoading = false
        
        after = nil
        hasMorePages = true
        posts = []
        
        loadPosts(account: account)
    }
}
