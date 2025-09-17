//
//  SubscribedSubredditListingView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-17.
//

import SwiftUI

struct SubscribedSubredditListingView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
    
    let onSelectCustomAction: ((SubscribedSubredditData) -> Void)?
    
    init(subscriptionListingViewModel: SubscriptionListingViewModel, onSelectCustomAction: ((SubscribedSubredditData) -> Void)? = nil) {
        self.subscriptionListingViewModel = subscriptionListingViewModel
        self.onSelectCustomAction = onSelectCustomAction
    }
    
    var body: some View {
        Group {
            if subscriptionListingViewModel.subredditSubscriptions.isEmpty {
                if subscriptionListingViewModel.isLoadingSubscriptions {
                    ProgressIndicator()
                } else {
                    Text("No subscribed subreddits")
                        .primaryText()
                }
            } else {
                List {
                    if !subscriptionListingViewModel.favoriteSubredditSubscriptions.isEmpty {
                        Section(header: Text("Favorite").listSectionHeader()) {
                            ForEach(subscriptionListingViewModel.favoriteSubredditSubscriptions, id: \.identityInView) { subscription in
                                SubscriptionItemView(text: subscription.name, iconUrl: subscription.iconUrl, isFavorite: subscription.isFavorite, action: {
                                    if let onSelectCustomAction = onSelectCustomAction {
                                        onSelectCustomAction(subscription)
                                    } else {
                                        navigationManager.path.append(AppNavigation.subredditDetails(subredditName: subscription.name))
                                    }
                                }) {
                                    subscription.isFavorite.toggle()
                                    Task {
                                        await subscriptionListingViewModel.toggleFavoriteSubreddit(subscription)
                                    }
                                }
                                .listPlainItemNoInsets()
                            }
                        }
                        .listPlainItem()
                    }
                    
                    Section(header: Text("All").listSectionHeader()) {
                        ForEach(subscriptionListingViewModel.subredditSubscriptions, id: \.identityInView) { subscription in
                            SubscriptionItemView(text: subscription.name, iconUrl: subscription.iconUrl, isFavorite: subscription.isFavorite, action: {
                                if let onSelectCustomAction = onSelectCustomAction {
                                    onSelectCustomAction(subscription)
                                } else {
                                    navigationManager.path.append(AppNavigation.subredditDetails(subredditName: subscription.name))
                                }
                            }) {
                                subscription.isFavorite.toggle()
                                Task {
                                    await subscriptionListingViewModel.toggleFavoriteSubreddit(subscription)
                                }
                            }
                            .listPlainItemNoInsets()
                        }
                    }
                    .listPlainItem()
                }
                .scrollBounceBehavior(.basedOnSize)
                .themedList()
            }
        }
    }
}
