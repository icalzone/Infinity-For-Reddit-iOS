
//
// SubredditSelectionView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI
import Swinject
import GRDB
import Alamofire

struct SubredditSelectionView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var subscriptionListingViewModel: SubscriptionListingViewModel
    
    init() {
        _subscriptionListingViewModel = StateObject(
            wrappedValue: SubscriptionListingViewModel(
                subscriptionListingRepository: SubscriptionListingRepository()
            )
        )
    }

    var body: some View {
        SubscribedSubredditListingView(subscriptionListingViewModel: subscriptionListingViewModel) { subscribedSubredditData in
            postSubmissionContextViewModel.selectedSubreddit = subscribedSubredditData
            dismiss()
        }
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Select a Subreddit")
        .task {
            await subscriptionListingViewModel.loadSubscriptionsOnline()
            await subscriptionListingViewModel.loadMyCustomFeedsOnline()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigationManager.path.removeLast()
                    navigationManager.path.append(AppNavigation.searchSubreddit)
                } label: {
                    SwiftUI.Image(systemName: "magnifyingglass")
                }
            }
        }
    }
}

