//
// SubmitLinkPostViewModel.swift
// Infinity for Reddit
//
// Created by joeylr2042 on 2025-09-13

import Foundation
import MarkdownUI
import Alamofire

@MainActor
class SubmitLinkPostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var urlString: String = ""
    @Published var content: String = ""
    @Published var selectedAccount: Account
    @Published var submitPostTask: Task<Void, Error>?
    @Published var submittedPostId: String?
    @Published var error: Error? = nil
    
    private let submitPostRepository: SubmitPostRepositoryProtocol
    
    init(submitPostRepository: SubmitPostRepositoryProtocol) {
        self.selectedAccount = AccountViewModel.shared.account
        self.submitPostRepository = submitPostRepository
    }
    
    func suggestTitle() async {
        var finalURL = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !finalURL.lowercased().hasPrefix("http://") &&
            !finalURL.lowercased().hasPrefix("https://") {
            finalURL = "https://" + finalURL
        }
        
        guard var components = URLComponents(string: finalURL), let host = components.host else {
            print("Invalid URL: \(finalURL)")
            return
        }
        
        if !host.contains("www.") && host.components(separatedBy: ".").count == 2 {
            components.host = "www." + host
        }
        
        guard let safeURL = components.url else {
            print("Failed to build safe URL")
            return
        }
        
        print("Final safe URL: \(safeURL)")
        
        AF.request(safeURL, method: .get)
            .validate()
            .responseString { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let html):
                    if let start = html.range(of: "<title>", options: .caseInsensitive),
                       let end = html.range(of: "</title>", options: .caseInsensitive) {
                        let extracted = String(html[start.upperBound..<end.lowerBound])
                            .trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        Task { @MainActor in
                            self.title = extracted
                        }
                    } else {
                        print("No <title> found in HTML")
                    }
                    
                case .failure(let error):
                    print("Suggest title failed: \(error.localizedDescription)")
                }
            }
    }
    
    func submitPost(
        subreddit: SubscribedSubredditData?,
        flair: Flair?,
        isSpoiler: Bool,
        isSensitive: Bool,
        receivePostReplyNotifications: Bool,
        isRichTextJSON: Bool
    ) {
        guard submitPostTask == nil else {
            return
        }
        
        guard let subreddit = subreddit, !subreddit.name.isEmpty else {
            error = PostSubmissionError.subredditNotSelectedError
            return
        }
        
        guard !title.isEmpty else {
            error = PostSubmissionError.noTitleError
            return
        }
        
        guard !urlString.isEmpty else {
            error = PostSubmissionError.noURLError
            return
        }
        
        submittedPostId = nil
        
        submitPostTask = Task {
            do {
                submittedPostId = try await submitPostRepository.submitLinkPost(
                    account: selectedAccount,
                    subredditName: subreddit.name,
                    title: title,
                    urlString: urlString,
                    content: content,
                    flair: flair,
                    isSpoiler: isSpoiler,
                    isSensitive: isSensitive,
                    receivePostReplyNotifications: receivePostReplyNotifications,
                    isRichTextJSON: isRichTextJSON
                )
            } catch {
                self.error = error
                print(error)
            }
            
            self.submitPostTask = nil
        }
    }
}
