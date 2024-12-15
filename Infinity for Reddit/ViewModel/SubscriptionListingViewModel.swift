//
//  SubscriptionListingViewModel.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-15.
//

import Foundation
import Combine

public class SubscriptionListingViewModel: ObservableObject {
    // MARK: - Properties
    @Published var subredditSubscriptions: [Subscription] = []
    @Published var userSubscriptions: [Subscription] = []
    private var subscriptionsPrivate: [Subscription] = []
    @Published var isLoading: Bool = false
    private var after: String? = nil
    private var cancellables = Set<AnyCancellable>()
    
    public let subscriptionListingRepository: SubscriptionListingRepositoryProtocol
    
    // MARK: - Initializer
    init(subscriptionListingRepository: SubscriptionListingRepositoryProtocol) {
        self.subscriptionListingRepository = subscriptionListingRepository
    }
    
    // MARK: - Methods
    
    /// Fetches the next page of posts
    public func loadSubscriptions() {
        guard !isLoading || (isLoading && after != nil && after?.isEmpty != true) else { return }
        
        isLoading = true
        
        subscriptionListingRepository.fetchSubscriptions(
            queries: ["limit": "100", "after": after ?? ""]
        )
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    DispatchQueue.main.async {
                        print("Error fetching subscriptions: \(error)")
                        self?.after = nil
                        self?.isLoading = false
                    }
                }
            }, receiveValue: { [weak self] subscriptionListing in
                guard let self = self else { return }
                if (subscriptionListing.subscriptions.isEmpty) {
                    // No more subscriptions
                    var subreddits = [Subscription]()
                    var users = [Subscription]()
                    for subscription in self.subscriptionsPrivate {
                        if subscription.subredditType == "user" {
                            subscription.displayName = String(subscription.displayName[subscription.displayName.index(subscription.displayName.startIndex, offsetBy: 2)...])
                            users.append(subscription)
                        } else {
                            subreddits.append(subscription)
                        }
                    }
                    
                    users.sort { $0.displayName.lowercased() < $1.displayName.lowercased() }
                    subreddits.sort { $0.displayName.lowercased() < $1.displayName.lowercased() }
                    
                    DispatchQueue.main.async {
                        self.after = nil
                        self.isLoading = false
                        self.subredditSubscriptions = subreddits
                        self.userSubscriptions = users
                    }
                } else {
                    self.after = subscriptionListing.after
                    
                    subscriptionsPrivate.append(contentsOf: subscriptionListing.subscriptions)
                    
                    if self.after == nil || self.after?.isEmpty == true {
                        var subreddits = [Subscription]()
                        var users = [Subscription]()
                        for subscription in self.subscriptionsPrivate {
                            if subscription.subredditType == "user" {
                                subscription.displayName = String(subscription.displayName[subscription.displayName.index(subscription.displayName.startIndex, offsetBy: 2)...])
                                users.append(subscription)
                            } else {
                                subreddits.append(subscription)
                            }
                        }
                        
                        users.sort { $0.displayName.lowercased() < $1.displayName.lowercased() }
                        subreddits.sort { $0.displayName.lowercased() < $1.displayName.lowercased() }
                        
                        DispatchQueue.main.async {
                            self.after = nil
                            self.isLoading = false
                            self.subredditSubscriptions = subreddits
                            self.userSubscriptions = users
                        }
                    } else {
                        loadSubscriptions()
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    /// Reloads posts from the first page
    func refreshPosts(account: Account) {
        // This is for user switching accounts. We have to force clear all load
        cancellables.forEach { $0.cancel() }
        
        isLoading = false
        
        after = nil
        subscriptionsPrivate = []
        
        loadSubscriptions()
    }
}
