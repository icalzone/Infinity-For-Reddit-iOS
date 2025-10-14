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
    @Published var capturedImage: UIImage? = nil
    
    init() {
        self.selectedAccount = AccountViewModel.shared.account
    }
    
    func setCapturedImage(_ image: UIImage) {
        capturedImage = image
        print("Updated captured image: \(image.description)")
    }
    
    func clearCapturedImage() {
        capturedImage = nil
        print("Cleared captured image")
    }
}
