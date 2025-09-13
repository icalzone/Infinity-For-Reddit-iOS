//
// SubmitLinkPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-13
        
import Foundation
import MarkdownUI

class SubmitLinkPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var selectedFlair: Flair?
    @Published var url: String = ""
    
    init() {
        self.selectedAccount = AccountViewModel.shared.account
    }
}
