//
//  SubscriptionsView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2024-12-03.
//

import SwiftUI
import Swinject
import GRDB
import Alamofire

struct SubscriptionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dependencyManager) private var dependencyManager: Container
    @EnvironmentObject var accountViewModel: AccountViewModel
    
    @StateObject var subscriptionListingViewModel: SubscriptionListingViewModel

    // State to track the selected picker index
    @State private var selectedOption = 0
    
    init() {
        guard let resolvedSession = DependencyManager.shared.container.resolve(Session.self) else {
            fatalError("Failed to resolve Session")
        }
        
        _subscriptionListingViewModel = StateObject(
            wrappedValue: SubscriptionListingViewModel(
                subscriptionListingRepository: SubscriptionListingRepository(
                    session: resolvedSession
                )
            )
        )
    }

    var body: some View {
        VStack {
            Picker("Options", selection: $selectedOption) {
                Text("Subreddits").tag(0)
                Text("Users").tag(1)
                Text("Custom Feed").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedOption == 0 {
                SubredditsView(subscriptionListingViewModel: subscriptionListingViewModel)
            } else if selectedOption == 1 {
                UsersView(subscriptionListingViewModel: subscriptionListingViewModel)
            } else {
                CustomFeedView()
            }

            Spacer() // Push content to the top
        }
        .navigationTitle("Subscriptions")
        .onAppear {
            subscriptionListingViewModel.loadSubscriptions()
        }
    }
    
    struct SubredditsView: View {
        @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
        
        var body: some View {
            Group {
                if subscriptionListingViewModel.isLoading {
                    Text("Is loading")
                } else if subscriptionListingViewModel.subredditSubscriptions.isEmpty {
                    Text("No subscribed subreddits")
                } else {
                    List {
                        ForEach(subscriptionListingViewModel.subredditSubscriptions, id: \.id) { subscription in
                            Text(subscription.displayName)
                        }
                    }.scrollBounceBehavior(.basedOnSize)
                }
            }
        }
    }

    struct UsersView: View {
        @ObservedObject var subscriptionListingViewModel: SubscriptionListingViewModel
        
        var body: some View {
            Group {
                if subscriptionListingViewModel.isLoading {
                    Text("Is loading")
                } else if subscriptionListingViewModel.userSubscriptions.isEmpty {
                    Text("No subscribed users")
                } else {
                    List {
                        ForEach(subscriptionListingViewModel.userSubscriptions, id: \.id) { subscription in
                            Text(subscription.displayName)
                        }
                    }.scrollBounceBehavior(.basedOnSize)
                }
            }
        }
    }

    struct CustomFeedView: View {
        var body: some View {
            Text("Custom Feed Content")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.1))
        }
    }
}
