//
// SubmitGalleryPostView.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-08-21

import SwiftUI
import MarkdownUI
import MijickCamera
import PhotosUI

struct SubmitGalleryPostView: View {
    @StateObject private var postSubmissionContextViewModel: PostSubmissionContextViewModel
    @StateObject private var submitGalleryPostViewModel: SubmitGalleryPostViewModel
    
    @FocusState private var markdownToolbarFocusedField: MarkdownFieldType?
    @FocusState private var focusedField: FieldType?
    
    @State private var contentTextViewCanFocus: Bool = true
    @State private var markdownToolbarHeight: CGFloat = 0
    @State private var titleSelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var bodySelectedRange: NSRange = NSRange(location: 0, length: 0)
    @State private var showMarkdownPreview: Bool = false
    @State private var showGallerySheet: Bool = false
    @State private var showPhotoPicker: Bool = false
    @State private var showCamera: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    init() {
        _postSubmissionContextViewModel = StateObject(
            wrappedValue: PostSubmissionContextViewModel(ruleRepository: RuleRepository(), flairRepository: FlairRepository())
        )
        _submitGalleryPostViewModel = StateObject(wrappedValue: SubmitGalleryPostViewModel())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(spacing: 0) {
                            UserPicker {
                                submitGalleryPostViewModel.selectedAccount = $0
                            }
                            
                            PostSubmissionSubredditChooserView(postSubmissionContextViewModel: postSubmissionContextViewModel) { subscribedSubredditData in
                                postSubmissionContextViewModel.selectedSubreddit = subscribedSubredditData
                            }
                            
                            Divider()
                            
                            PostSubmissionContextView(postSubmissionContextViewModel: postSubmissionContextViewModel)
                            
                            Divider()
                            
                            CustomTextField(
                                "Title",
                                text: $submitGalleryPostViewModel.title,
                                singleLine: true,
                                keyboardType: .default,
                                showBorder: false,
                                fieldType: .title,
                                focusedField: $focusedField
                            )
                            .padding(16)
                            
                            ZStack(alignment: .topLeading) {
                                MarkdownTextField(text: $submitGalleryPostViewModel.content, selectedRange: $bodySelectedRange, canFocus: $contentTextViewCanFocus)
                                    .contentShape(Rectangle())
                                
                                if submitGalleryPostViewModel.content.isEmpty {
                                    Text("Content")
                                        .secondaryText()
                                }
                            }
                            .padding(16)
                            
                            if !submitGalleryPostViewModel.capturedImages.isEmpty {
                                VStack(spacing: 16) {
                                    GalleryGridView(images: submitGalleryPostViewModel.capturedImages){
                                        showGallerySheet = true
                                    }
                                }
                            } else {
                                GallerySelectionToolbar{
                                    showGallerySheet = true
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: markdownToolbarHeight)
                    
                }
                
                MarkdownToolbar(
                    text: $submitGalleryPostViewModel.content,
                    selectedRange: $bodySelectedRange,
                    toolbarHeight: $markdownToolbarHeight,
                    focusedField: $markdownToolbarFocusedField
                )
            }
            
            KeyboardToolbar {
                contentTextViewCanFocus = false
                markdownToolbarFocusedField = nil
                focusedField = nil
            }
        }
        .frame(maxHeight: .infinity)
        .themedNavigationBar()
        .addTitleToInlineNavigationBar("Gallery Post")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showMarkdownPreview = true
                } label: {
                    SwiftUI.Image(systemName: "eye")
                }
                
                Button {
                    print("Submit Gallery Post")
                } label: {
                    SwiftUI.Image(systemName: "paperplane.fill")
                }
            }
        }
        .sheet(isPresented: $showMarkdownPreview) {
            MarkdownViewerSheet(markdown: submitGalleryPostViewModel.content)
        }
        .sheet(isPresented: $showGallerySheet) {
            GallerySelectionSheet(
                onCameraTap: {
                    showCamera = true
                    showGallerySheet = false
                },
                onPhotoPickerTap: {
                    showPhotoPicker = true
                    showGallerySheet = false
                }
            )
            .presentationDragIndicator(.visible)
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItem,
            matching: .images
        )
        .onChange(of: selectedPhotoItem) { _, newSelectedItem in
            Task {
                if let selectedItem = newSelectedItem,
                   let imageData = try? await selectedItem.loadTransferable(type: Data.self),
                   let pickedImage = UIImage(data: imageData) {
                    submitGalleryPostViewModel.addImage(pickedImage)
                } else {
                    // Error handling
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            if Utils.checkCameraAvailability() {
                MCamera()
                    .onImageCaptured { capturedImage, controller in
                        submitGalleryPostViewModel.addImage(capturedImage)
                        controller.closeMCamera()
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
    }
    
    private enum FieldType: Hashable {
        case title
    }
}

private struct GallerySelectionToolbar: View {
    @EnvironmentObject private var customThemeViewModel: CustomThemeViewModel
    
    let onTapGallery: () -> Void
    let buttonSize: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 32) {
            Button {
                onTapGallery()
            } label: {
                SwiftUI.Image(systemName: "photo.fill.on.rectangle.fill")
                    .font(.system(size: buttonSize))
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Circle().fill(Color(hex: customThemeViewModel.currentCustomTheme.colorAccent)))
            }
        }
        .padding(16)
    }
}

private struct GalleryGridView: View {
    let images: [UIImage]
    let onAddTap: () -> Void
    private let columns: Int = 2
    private let spacing: CGFloat = 10
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack (spacing: spacing) {
                    let totalSpacing = spacing * CGFloat(columns - 1)
                    let imageWidth = (geometry.size.width - totalSpacing - 32) / CGFloat(columns)
                    
                    ForEach(rows.indices, id: \.self) { rowIndex in
                        let rowItems = rows[rowIndex]
                        
                        HStack(spacing: spacing) {
                            ForEach(rowItems, id: \.self) { item in
                                switch item {
                                case .image(let uiImage):
                                    SwiftUI.Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: imageWidth, height: imageWidth)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                case .addButton:
                                    GallerySelectionToolbar(onTapGallery: onAddTap)
                                        .frame(width: imageWidth, height: imageWidth)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(height: calculateContentHeight(for: images.count))
    }
    
    private var rows: [[GridItemType]] {
        // Define a unified enum type for clarity
        let maxCount = 20
        var items: [GridItemType] = images.map { .image($0) }
        if images.count < maxCount {
            items.append(.addButton)
        }
        
        // Split items into rows
        return stride(from: 0, to: items.count, by: columns).map {
            Array(items[$0 ..< min($0 + columns, items.count)])
        }
    }
    
    private func calculateContentHeight(for count: Int) -> CGFloat {
        let rowsCount = ceil(Double(count) / Double(columns))
        let imageSize = UIScreen.main.bounds.width / CGFloat(columns)
        let spacingTotal = spacing * CGFloat(rowsCount - 1)
        return (imageSize * CGFloat(rowsCount)) + spacingTotal + 150
    }
    
    private enum GridItemType: Hashable {
        case image(UIImage)
        case addButton
    }
}


