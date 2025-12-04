//
// SubredditRulesView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-27

import SwiftUI
import MarkdownUI

struct SubredditRulesSheet: View {
    @EnvironmentObject private var subredditChooseViewModel: PostSubmissionContextViewModel
    
    var body: some View {
        Group {
            if subredditChooseViewModel.rules.isEmpty {
                ZStack {
                    if subredditChooseViewModel.isLoadingRules {
                        ProgressIndicator()
                    } else if let error = subredditChooseViewModel.rulesError {
                        Text("Unable to load posts. Tap to retry. Error: \(error.localizedDescription)")
                            .primaryText()
                            .padding(16)
                            .onTapGesture {
                                subredditChooseViewModel.fetchRules()
                            }
                    } else {
                        Text("No subreddit-specific rules.")
                            .primaryText()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(subredditChooseViewModel.rules, id: \.shortName) { rule in
                            Markdown(rule.shortName)
                                .markdownTextStyle {
                                    FontSize(16)
                                }
                                .themedMarkdown()
                                .padding(.vertical, 22)
                            
                            Markdown(rule.description)
                                .markdownTextStyle {
                                    FontSize(14)
                                }
                                .themedMarkdown()
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .themedNavigationBar()
        .onAppear {
            subredditChooseViewModel.fetchRules()
        }
    }
}
