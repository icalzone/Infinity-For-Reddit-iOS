//
//  VotesText.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-11.
//

import SwiftUI

struct VotesText: View {
    @AppStorage(InterfaceUserDefaultsUtils.showAbsoluteNumberOfVotesKey, store: .interface) private var showAbsoluteNumberOfVotes: Bool = true
    
    let votes: Int
    let hideNVotes: Bool
    
    private var formattedVotes: String {
        if showAbsoluteNumberOfVotes || abs(votes) < 1000 {
            return String(votes)
        } else {
            return String(format: "%.1fK", Float(votes) / 1000.0)
        }
    }
    
    var body: some View {
        Text(hideNVotes ? "Hidden" : formattedVotes)
    }
}
