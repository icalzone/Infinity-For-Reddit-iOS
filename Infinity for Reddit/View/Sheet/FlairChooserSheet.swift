//
// FlairChooserSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-03

import SwiftUI

struct FlairChooserSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var postSubmissionContextViewModel: PostSubmissionContextViewModel
    
    let onFlairSelected: (Flair) -> Void
    
    var body: some View {
        ScrollView {
            if postSubmissionContextViewModel.isLoadingFlairs {
                ProgressIndicator()
            } else {
                VStack(spacing: 0) {
                    if !postSubmissionContextViewModel.flairs.isEmpty {
                        ForEach(postSubmissionContextViewModel.flairs, id: \.id) { flair in
                            TouchRipple(action: {
                                onFlairSelected(flair)
                                dismiss()
                            }) {
                                FlairRowView(flair: flair)
                            }
                        }
                    } else {
                        Text("No flairs available")
                            .secondaryText()
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}

