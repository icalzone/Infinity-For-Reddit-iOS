//
// PostSubmissionFlairChooserSheet.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-03

import SwiftUI

struct PostSubmissionFlairChooserSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var postSubmissionContextViewModel: PostSubmissionContextViewModel
    
    @FocusState private var focusedField: FieldType?
    
    @State private var showCustomizeFlairTextSheet: Bool = false
    @State private var flairToBeCustomized: Flair?
    
    let onFlairSelected: (Flair) -> Void
    
    var body: some View {
        SheetRootView {
            if postSubmissionContextViewModel.flairs.isEmpty {
                ZStack {
                    if postSubmissionContextViewModel.isLoadingFlairs {
                        ProgressIndicator()
                    } else if let error = postSubmissionContextViewModel.flairsError {
                        Text("Unable to load flairs. Tap to retry. Error: \(error.localizedDescription)")
                            .primaryText()
                            .padding(16)
                            .onTapGesture {
                                postSubmissionContextViewModel.fetchFlairs()
                            }
                    } else {
                        Text("No flairs available")
                            .primaryText()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(postSubmissionContextViewModel.flairs, id: \.id) { flair in
                            TouchRipple(action: {
                                onFlairSelected(flair)
                                dismiss()
                            }) {
                                FlairRowView(flair: flair) {
                                    flairToBeCustomized = flair
                                    withAnimation(.linear(duration: 0.2)) {
                                        showCustomizeFlairTextSheet = true
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            postSubmissionContextViewModel.fetchFlairs()
        }
        .overlay {
            if showCustomizeFlairTextSheet {
                CustomAlert(title: "Customize Post Flair Text", confirmButtonText: "OK", isPresented: $showCustomizeFlairTextSheet) {
                    VStack(spacing: 16) {
                        CustomTextField(
                            "Post Flair Text",
                            text: Binding<String>(
                                get: {
                                    flairToBeCustomized?.text ?? ""
                                }, set: { newValue in
                                    flairToBeCustomized?.text = newValue
                                }
                            ),
                            singleLine: true,
                            autocapitalization: .never,
                            characterLimit: 64,
                            fieldType: .customizePostFilterText,
                            focusedField: $focusedField
                        )
                        .submitLabel(.done)
                        .onSubmit {
                            if let flairToBeCustomized {
                                onFlairSelected(flairToBeCustomized)
                                dismiss()
                            }
                        }
                        
                        RowText("Maximum 64 characters.")
                            .secondaryText()
                    }
                } onConfirm: {
                    if let flairToBeCustomized {
                        onFlairSelected(flairToBeCustomized)
                        dismiss()
                    }
                }
            }
        }
    }
    
    enum FieldType: Hashable {
        case customizePostFilterText
    }
}

