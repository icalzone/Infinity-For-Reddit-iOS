//
// SubmitGalleryPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-10-04
        
import Foundation
import UIKit
import PhotosUI

class SubmitGalleryPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var capturedImages: [UIImage] = []
    
    init() {
        self.selectedAccount = AccountViewModel.shared.account
    }
    
    func addImage(_ image: UIImage) {
        if capturedImages.count < 20 {
            capturedImages.append(image)
        }
    }
    
    func clearCapturedImages() {
        capturedImages.removeAll()
    }
    
    func deleteCapturedImage(at index: Int) {
        guard index >= 0 && index < capturedImages.count else { return }
        capturedImages.remove(at: index)
    }
}
