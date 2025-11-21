//
//  SubscriptionSelectionMode.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-19.
//

import IdentifiedCollections

enum SubscriptionSelectionMode {
    case noSelection
    case searchInThing(onSelectSearchInThing: (Thing) -> Void)
    case subredditAndUserInCustomFeed(selectedSubredditsAndUsersInCustomFeed: IdentifiedArrayOf<Thing>, onSelectMultipleSubscriptions: ([Thing]) -> Void)
}
