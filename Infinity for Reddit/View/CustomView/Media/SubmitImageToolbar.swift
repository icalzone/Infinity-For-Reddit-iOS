//
// SubmitImageToolbar.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-24
        
import SwiftUI

struct SubmitImageToolbar: View {
    
    private let buttonSize: CGFloat = 24
    let onCameraTap: () -> Void
    let onPhotoPickerTap: () -> Void

    var body: some View {
        HStack(spacing: 32) {
            Button {
                onCameraTap()
            } label: {
                SwiftUI.Image(systemName: "camera.fill")
                    .font(.system(size: buttonSize))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color(hex: "ED3770")))
            }

            Button {
                onPhotoPickerTap()
            } label: {
                SwiftUI.Image(systemName: "photo.fill.on.rectangle.fill")
                    .font(.system(size: buttonSize))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Circle().fill(Color(hex: "ED3770")))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .padding(.bottom, 8)
    }
}
