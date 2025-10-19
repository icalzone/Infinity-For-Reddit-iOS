//
//  UploadedImageView.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-10-18.
//

import SwiftUI

struct UploadedImageView: View {
    @ObservedObject var uploadedImage: UploadedImage

    let onInsertImage: () -> Void
    
    var body: some View {
        ZStack {
            SwiftUI.Image(uiImage: uploadedImage.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .listPlainItemNoInsets()
            
            if uploadedImage.isUploading {
                ProgressIndicator()
            } else if !uploadedImage.isUploaded && uploadedImage.uploadError != nil {
                SwiftUI.Image(systemName: "arrow.clockwise.circle.fill")
                    .foregroundStyle(.black)
                    .onTapGesture {
                        uploadedImage.upload()
                    }
            }
        }
        .onTapGesture {
            if uploadedImage.isUploaded {
                onInsertImage()
            }
        }
    }
}
