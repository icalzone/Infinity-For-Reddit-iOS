//
//  CrosspostView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-11-18.
//

import SwiftUI

struct CrosspostView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @EnvironmentObject private var snackbarManager: SnackbarManager
    
    @StateObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @StateObject private var crosspostViewModel: CrosspostViewModel
    
    @FocusState private var focusedField: FieldType?

    @State private var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    
    init(postToBeCrossposted: Post) {
        _postSubmissionContextViewModel = StateObject(
            wrappedValue: PostSubmissionContextViewModel(ruleRepository: RuleRepository(), flairRepository: FlairRepository())
        )
        _crosspostViewModel = StateObject(
            wrappedValue: CrosspostViewModel(
                postToBeCrossposted: postToBeCrossposted,
                submitPostRepository: SubmitPostRepository()
            )
        )
    }
    
    var body: some View {
        RootView {
            VStack(spacing: 0) {
                ZStack {
                    ScrollView {
                        VStack(spacing: 0) {
                            UserPicker {
                                crosspostViewModel.selectedAccount = $0
                            }
                            
                            PostSubmissionSubredditChooserView(postSubmissionContextViewModel: postSubmissionContextViewModel) { subscribedSubredditData in
                                postSubmissionContextViewModel.selectedSubreddit = subscribedSubredditData
                            }
                            
                            Divider()
                            
                            PostSubmissionContextView(postSubmissionContextViewModel: postSubmissionContextViewModel)
                            
                            Divider()
                            
                            CustomTextField(
                                "Title",
                                text: $crosspostViewModel.title,
                                singleLine: true,
                                keyboardType: .default,
                                showBorder: false,
                                fieldType: .title,
                                focusedField: $focusedField
                            )
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    }
                }
                
                KeyboardToolbar {
                    focusedField = nil
                }
            }
        }
        .frame(maxHeight: .infinity)
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Crosspost")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    crosspostViewModel.submitPost(
                        subreddit: postSubmissionContextViewModel.selectedSubreddit,
                        flair: postSubmissionContextViewModel.selectedFlair,
                        isSpoiler: postSubmissionContextViewModel.isSpoiler,
                        isSensitive: postSubmissionContextViewModel.isSensitive,
                        receivePostReplyNotifications: postSubmissionContextViewModel.receivePostReplyNotification
                    )
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .onChange(of: crosspostViewModel.submitPostTask) { _, newValue in
            if newValue != nil {
                snackbarManager.showSnackbar(
                    text: "Submitting. Please wait...",
                    autoDismiss: false,
                    canDismissByGesture: false
                )
            }
        }
        .onChange(of: crosspostViewModel.submittedPostId) { _, newValue in
            if let id = newValue {
                snackbarManager.dismiss()
                navigationManager.replaceCurrentScreen(AppNavigation.postDetailsWithId(postId: id))
            }
        }
        .onReceive(crosspostViewModel.$error) { newValue in
            if let error = newValue {
                snackbarManager.showSnackbar(text: error.localizedDescription)
            }
        }
    }
    
    private enum FieldType: Hashable {
        case title
    }
}
