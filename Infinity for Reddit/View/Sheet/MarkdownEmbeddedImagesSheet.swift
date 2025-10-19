//
//  MarkdownEmbeddedImagesSheet.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-18.
//

import SwiftUI

struct MarkdownEmbeddedImagesSheet: View {
    @Binding var embeddedImages: [UploadedImage]
    
    @FocusState private var focusedField: FieldType?
    
    @State private var showCaptionAlert: Bool = false
    @State private var caption: String = ""
    @State private var selectedImage: UploadedImage?
    
    let onAddImage: () -> Void
    let onInsertImage: (UploadedImage, String) -> Void
    
    var body: some View {
        VStack {
            List {
                ForEach(embeddedImages, id: \.id) { embeddedImage in
                    UploadedImageView(uploadedImage: embeddedImage, onInsertImage: {
                        caption = ""
                        selectedImage = embeddedImage
                        showCaptionAlert = true
                    })
                    .listPlainItemNoInsets()
                }
            }
            .themedList()
            
            Button {
                onAddImage()
            } label: {
                Text("Upload Image")
                    .buttonText()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .filledButton()
            .excludeFromTouchRipple()
            .padding(.horizontal, 32)
        }
        .overlay(
            CustomAlert(title: "Set Caption", isPresented: $showCaptionAlert) {
                CustomTextField("Caption (not required)",
                                text: $caption,
                                singleLine: true,
                                fieldType: .caption,
                                focusedField: $focusedField)
            } onConfirm: {
                if let selectedImage {
                    onInsertImage(selectedImage, caption)
                }
            }
        )
    }
    
    private enum FieldType: Hashable {
        case caption
    }
}
