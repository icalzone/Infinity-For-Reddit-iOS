//
//  PostSubmissionContextView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-09-22.
//

import SwiftUI

struct PostSubmissionContextView: View {
    @ObservedObject var postSubmissionContextViewModel: PostSubmissionContextViewModel
    
    @State private var showFlairSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                if postSubmissionContextViewModel.selectedSubreddit != nil {
                    FlairFilledButton(selectedFlair: postSubmissionContextViewModel.selectedFlair) {
                        if postSubmissionContextViewModel.selectedFlair != nil {
                            postSubmissionContextViewModel.selectedFlair = nil
                        } else {
                            Task {
                                await postSubmissionContextViewModel.fetchFlairs()
                                showFlairSheet = true
                            }
                        }
                    }
                }
                
                SpoilerFilledButton(isSpoiler: $postSubmissionContextViewModel.isSpoiler)
                
                SensitiveFilledButton(isSensitive: $postSubmissionContextViewModel.isSensitive)
        
                Spacer()
            }
            .padding(16)
            
            TouchRipple(action: {
                postSubmissionContextViewModel.receiveReplyNotification.toggle()
            }) {
                HStack {
                    RowText("Receive post reply notifications")
                        .secondaryText()
                    
                    Toggle(isOn: $postSubmissionContextViewModel.receiveReplyNotification) {}
                        .labelsHidden()
                        .themedToggle()
                        .excludeFromTouchRipple()
                }
                .padding(16)
            }
        }
        .sheet(isPresented: $showFlairSheet) {
            FlairChooserSheet(postSubmissionContextViewModel: postSubmissionContextViewModel) { flair in
                postSubmissionContextViewModel.selectedFlair = flair
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}
