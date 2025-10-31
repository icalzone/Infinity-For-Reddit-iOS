//
//  SubmitCommentView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-08-15.
//

import SwiftUI
import MarkdownUI
import PhotosUI
import MijickCamera
import GiphyUISDK

struct SubmitCommentView: View {
    @EnvironmentObject private var commentSubmissionShareableViewModel: CommentSubmissionShareableViewModel
    @EnvironmentObject private var snackbarManager: SnackbarManager
    @EnvironmentObject private var navigationManager: NavigationManager
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var submitCommentViewModel: SubmitCommentViewModel
    
    @State private var selectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var textViewCanFocus: Bool = true
    @State private var toolbarHeight: CGFloat = 0
    @FocusState private var markdownFocusedField: MarkdownFieldType?
    @State private var showMarkdownPreview = false
    @State private var cursorPosition: CGPoint = .zero
    @State private var showEmbeddedImagesSheet: Bool = false
    @State private var showGiphyGifSheet: Bool = false
    @State private var showCamera: Bool = false
    @State private var showPhotoPicker: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    
    init(parent: CommentParent) {
        _submitCommentViewModel = StateObject(
            wrappedValue: SubmitCommentViewModel(
                commentParent: parent,
                submitCommentRepository: SubmitCommentRepository(),
                mediaUploadRepository: MediaUploadRepository()
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            if let title = submitCommentViewModel.commentParent.title {
                                RowText(title)
                                    .primaryText()
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                    .padding(.bottom, 8)
                            } else {
                                Spacer()
                                    .frame(height: 8)
                            }
                            
                            if let bodyProcessedMarkdown = submitCommentViewModel.commentParent.bodyProcessedMarkdown {
                                Markdown(bodyProcessedMarkdown)
                                    .markdownImageProvider(WebImageProvider(mediaMetadata: submitCommentViewModel.commentParent.mediaMetadata))
                                    .font(.system(size: 24))
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                                    .padding(.bottom, 16)
                                    .themedPostCommentMarkdown()
                                    .markdownLinkHandler { url in
                                        navigationManager.openLink(url)
                                    }
                            } else if let body = submitCommentViewModel.commentParent.body, !body.isEmpty {
                                Markdown(body)
                                    .markdownImageProvider(WebImageProvider(mediaMetadata: submitCommentViewModel.commentParent.mediaMetadata))
                                    .font(.system(size: 24))
                                    .padding(.horizontal, 16)
                                    .padding(.top, 8)
                                    .padding(.bottom, 16)
                                    .themedPostCommentMarkdown()
                                    .markdownLinkHandler { url in
                                        navigationManager.openLink(url)
                                    }
                            } else {
                                Spacer()
                                    .frame(height: 8)
                            }
                            
                            Divider()
                            
                            UserPicker {
                                submitCommentViewModel.selectedAccount = $0
                            }
                            
                            MarkdownTextField(hint: "Your interesting thoughts here", text: $submitCommentViewModel.text, selectedRange: $selectedRange, canFocus: $textViewCanFocus)
                                .contentShape(Rectangle())
                                .padding(16)
                        }
                    }
                    
                    Spacer()
                        .frame(height: toolbarHeight)
                }
                
                MarkdownToolbar(
                    text: $submitCommentViewModel.text,
                    selectedRange: $selectedRange,
                    toolbarHeight: $toolbarHeight,
                    focusedField: $markdownFocusedField,
                    enableImageUpload: true,
                    enableGifChooser: true,
                    onImageUpload: {
                        showEmbeddedImagesSheet = true
                    },
                    onChooseGif: {
                        showGiphyGifSheet = true
                    }
                )
            }
            
            KeyboardToolbar {
                textViewCanFocus = false
                markdownFocusedField = nil
            }
        }
        .frame(maxHeight: .infinity)
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Send Comment")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showMarkdownPreview = true
                } label: {
                    SwiftUI.Image(systemName: "eye")
                }
                
                Button {
                    Task {
                        let sentComment = await submitCommentViewModel.submitComment()
                        if let sentComment = sentComment {
                            snackbarManager.showSnackbar(text: "Submitting comment. Please wait.")
                            await MainActor.run {
                                commentSubmissionShareableViewModel.sentComment = sentComment
                                snackbarManager.dismiss()
                                dismiss()
                            }
                        } else {
                            snackbarManager.showSnackbar(text: "Failed to submit comment. Error: \(submitCommentViewModel.error?.localizedDescription ?? "Unknown error")")
                            // Failed to submit this comment
                        }
                    }
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .sheet(isPresented: $showMarkdownPreview) {
            MarkdownViewerSheet(markdown: submitCommentViewModel.text)
        }
        .sheet(isPresented: $showEmbeddedImagesSheet) {
            MarkdownEmbeddedImagesSheet(embeddedImages: $submitCommentViewModel.embeddedImages, onCaptureImage: {
                showEmbeddedImagesSheet = false
                showCamera = true
            }, onSelectImage: {
                showEmbeddedImagesSheet = false
                showPhotoPicker = true
            }, onInsertImage: { uploadedImage, caption in
                showEmbeddedImagesSheet = false
                
                guard let range = Range(selectedRange, in: submitCommentViewModel.text) else {
                    return
                }
                
                let beforeRange = submitCommentViewModel.text[..<range.lowerBound]
                let afterRange = submitCommentViewModel.text[range.upperBound...]

                let leftCount = min(2, beforeRange.count)
                let leftStart = beforeRange.index(beforeRange.endIndex, offsetBy: -leftCount)
                let leftSlice = beforeRange[leftStart..<beforeRange.endIndex]

                let leftNewlines: Int
                if leftSlice.allSatisfy({ $0 == "\n" || $0.isWhitespace }) {
                    leftNewlines = leftSlice.isEmpty ? 2 : leftSlice.filter { $0 == "\n" }.count
                } else if leftSlice.hasSuffix("\n") {
                    leftNewlines = 1
                } else {
                    leftNewlines = 0
                }

                let rightCount = min(2, afterRange.count)
                let rightEnd = afterRange.index(afterRange.startIndex, offsetBy: rightCount)
                let rightSlice = afterRange[afterRange.startIndex..<rightEnd]

                let rightNewlines: Int
                if rightSlice.allSatisfy({ $0 == "\n" || $0.isWhitespace }) {
                    rightNewlines = rightSlice.isEmpty ? 2 : rightSlice.filter { $0 == "\n" }.count
                } else if rightSlice.hasPrefix("\n") {
                    rightNewlines = 1
                } else {
                    rightNewlines = 0
                }
                
                let imageSyntax = "\(String(repeating: "\n", count: max(0, 2 - leftNewlines)))![\(caption)](\(uploadedImage.imageId ?? ""))\(String(repeating: "\n", count: max(0, 2 - rightNewlines)))"
                
                let newText: String
                if selectedRange.length > 0 {
                    newText = submitCommentViewModel.text.replacingCharacters(in: range, with: imageSyntax)
                    selectedRange = NSRange(location: selectedRange.location,
                                            length: imageSyntax.count)
                } else {
                    newText = submitCommentViewModel.text.inserting(imageSyntax, at: selectedRange.location)
                    selectedRange = NSRange(location: selectedRange.location + imageSyntax.count,
                                            length: 0)
                }
                submitCommentViewModel.text = newText
            })
        }
        .sheet(isPresented: $showGiphyGifSheet) {
            GiphyView()
                .onSearch { term in
                    print("onSearch called")
                }
                .onCreate { term in
                    print("onCreate called")
                }
                .onSelectMedia { media, contentType in
                    print("onSelectMedia called")
                }
                .onDismiss {
                    print("onDismiss called")
                }
                .onTapSuggestion { suggestion in
                    print("onTapSuggestion called")
                }
                .onError { error in
                    print("onError called")
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
                .ignoresSafeArea(edges: .bottom)
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .fullScreenCover(isPresented: $showCamera) {
            if Utils.checkCameraAvailability() {
                MCamera()
                    .onImageCaptured { capturedImage, controller in
                        submitCommentViewModel.addEmbeddedImage(capturedImage)
                        controller.closeMCamera()
                        showEmbeddedImagesSheet = true
                    }
                    .setCloseMCameraAction {
                        showCamera = false
                    }
                    .setCameraOutputType(.photo)
                    .setAudioAvailability(false)
                    .setCameraScreen { cameraManager, id, closeMCameraAction in
                        DefaultCameraScreen(
                            cameraManager: cameraManager,
                            namespace: id,
                            closeMCameraAction: closeMCameraAction
                        ).cameraOutputSwitchAllowed(false)
                    }
                    .startSession()
            } else {
                VStack {
                    Text("Camera not available")
                        .padding(.bottom, 60)
                    
                    Button("Close") {
                        showCamera = false
                    }
                    .filledButton()
                }
            }
        }
        .onChange(of: selectedPhotoItem) { _, newSelectedItem in
            showEmbeddedImagesSheet = true
            Task {
                if let selectedItem = newSelectedItem,
                   let imageData = try? await selectedItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: imageData) {
                    print(Utils.isGIF(imageData: imageData))
                    submitCommentViewModel.addEmbeddedImage(image)
                } else {
                    // Error handling
                }
            }
        }
    }
}

enum CommentParent: Hashable {
    case post(parentPost: Post)
    case comment(parentComment: Comment)
    
    var parentFullname: String? {
        switch self {
        case .post(let parentPost):
            return parentPost.name
        case .comment(let parentComment):
            return parentComment.name
        }
    }
    
    var childCommentDepth: Int {
        switch self {
        case .post:
            return 0
        case .comment(let parentComment):
            return parentComment.depth + 1
        }
    }
    
    var title: String? {
        switch self {
        case .post(let parentPost):
            return parentPost.title
        case .comment:
            return nil
        }
    }
    
    var bodyProcessedMarkdown: MarkdownContent? {
        switch self {
        case .post(let parentPost):
            return parentPost.selftextProcessedMarkdown
        case .comment(let parentComment):
            return parentComment.bodyProcessedMarkdown
        }
    }
    
    var body: String? {
        switch self {
        case .post(let parentPost):
            return parentPost.selftext
        case .comment(let parentComment):
            return parentComment.body
        }
    }
    
    var mediaMetadata: [String: MediaMetadata]? {
        switch self {
        case .post(let parentPost):
            return parentPost.mediaMetadata
        case .comment(let parentComment):
            return parentComment.mediaMetadata
        }
    }
}
