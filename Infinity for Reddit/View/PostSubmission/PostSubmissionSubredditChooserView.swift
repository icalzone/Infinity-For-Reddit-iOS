//
// PostSubmissionSubredditChooserView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21
        
import SwiftUI

struct PostSubmissionSubredditChooserView: View {
    @EnvironmentObject var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @EnvironmentObject var accountViewModel: AccountViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject var themeViewModel = CustomThemeViewModel()
    
    @State private var showNoSubredditAlert = false
    @State private var showRulesSheet = false
    
    var text: String
    var iconUrl: String?
    var action: () -> Void
    
    private let iconSize: CGFloat = 24
    
    var body: some View {
        TouchRipple(action: action) {
            HStack(spacing: 0) {
                if let icon = postSubmissionContextViewModel.selectedSubreddit?.iconUrl {
                    CustomWebImage(
                        icon,
                        width: iconSize,
                        height: iconSize,
                        circleClipped: true,
                        handleImageTapGesture: false
                    )
                } else {
                    Spacer()
                        .frame(width: iconSize)
                }
                
                Spacer()
                    .frame(width: 24)
                
                RowText(postSubmissionContextViewModel.selectedSubreddit?.name ?? text)
                    .primaryText()
                
                Spacer()
                    .frame(width: 24)
                
                Button("Rules") {
                    if postSubmissionContextViewModel.selectedSubreddit == nil {
                        showNoSubredditAlert = true
                    } else {
                        showRulesSheet = true
                        Task {
                            await postSubmissionContextViewModel.fetchRules()
                        }
                    }
                }
                .filledButton()
                .excludeFromTouchRipple()
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .contentShape(Rectangle())
        }
        .alert("No Subreddit Selected",
               isPresented: $showNoSubredditAlert,
               actions: { Button("OK", role: .cancel) { } },
               message: { Text("Please select a subreddit first") }
        )
        .sheet(isPresented: $showRulesSheet) {
            SubredditRulesView()
                .environmentObject(postSubmissionContextViewModel)
        }
    }
}

