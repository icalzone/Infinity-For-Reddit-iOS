//
//  CommentInterfaceViewModel.swift
//  Infinity for Reddit
//
//  Created by joeylr2042 on 2024-12-13.
//

import SwiftUI
import Combine
import GRDB
import Swinject

class CommentInterfaceViewModel: ObservableObject {
    // MARK: - Properties
    @Published var showTopLevelCommentsFirst: Bool
    @Published var showCommentDivider: Bool
    @Published var commentToolbarHiddenByDefault: Bool
    @Published var clickToShowHideCommentToolbar: Bool
    @Published var fullyCollapseComment: Bool
    @Published var showAuthorAvatar: Bool
    @Published var alwaysShowNumberOfChildComments: Bool
    @Published var hideNumberOfVotes: Bool
    @Published var showFewerToolbarOptionsStartingFromLevel: Int
    @Published var embeddedMediaType: Int
    
    let SHOW_TOP_LEVEL_COMMENTS_FIRST = UserDefaultsUtils.SHOW_TOP_LEVEL_COMMENTS_FIRST
    let SHOW_COMMENT_DIVIDER = UserDefaultsUtils.SHOW_COMMENT_DIVIDER
    let COMMENT_TOOLBAR_HIDDEN = UserDefaultsUtils.COMMENT_TOOLBAR_HIDDEN
    let COMMENT_TOOLBAR_HIDE_ON_CLICK = UserDefaultsUtils.COMMENT_TOOLBAR_HIDE_ON_CLICK
    let FULLY_COLLAPSE_COMMENT = UserDefaultsUtils.FULLY_COLLAPSE_COMMENT
    let SHOW_AUTHOR_AVATAR = UserDefaultsUtils.SHOW_AUTHOR_AVATAR
    let ALWAYS_SHOW_CHILD_COMMENT_COUNT = UserDefaultsUtils.ALWAYS_SHOW_CHILD_COMMENT_COUNT
    let HIDE_THE_NUMBER_OF_VOTES_IN_COMMENTS = UserDefaultsUtils.HIDE_THE_NUMBER_OF_VOTES_IN_COMMENTS
    let SHOW_FEWER_TOOLBAR_OPTIONS_THRESHOLD = UserDefaultsUtils.SHOW_FEWER_TOOLBAR_OPTIONS_THRESHOLD
    let EMBEDDED_MEDIA_TYPE = UserDefaultsUtils.EMBEDDED_MEDIA_TYPE
    
    let toolBarOptionLevels = ["Level 0", "Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8", "Level 9", "Level 10"]
    let embeddedMediaTypes = ["All", "Image and GIF", "Image and emote", "GIF and emote", "Image", "GIF", "Emote", "None"]
    private let userDefaults: UserDefaults
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    init(){
        guard let resolvedUserDefaults = DependencyManager.shared.container.resolve(UserDefaults.self) else {
            fatalError("Failed to resolve UserDefaults")
        }
        self.userDefaults = resolvedUserDefaults
        
        if userDefaults.object(forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST) == nil {
            userDefaults.set(false, forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST)
        }
        if userDefaults.object(forKey: SHOW_COMMENT_DIVIDER) == nil {
            userDefaults.set(false, forKey: SHOW_COMMENT_DIVIDER)
        }
        if userDefaults.object(forKey: COMMENT_TOOLBAR_HIDDEN) == nil {
            userDefaults.set(false, forKey: COMMENT_TOOLBAR_HIDDEN)
        }
        if userDefaults.object(forKey: COMMENT_TOOLBAR_HIDE_ON_CLICK) == nil {
            userDefaults.set(false, forKey: COMMENT_TOOLBAR_HIDE_ON_CLICK)
        }
        if userDefaults.object(forKey: FULLY_COLLAPSE_COMMENT) == nil {
            userDefaults.set(false, forKey: FULLY_COLLAPSE_COMMENT)
        }
        if userDefaults.object(forKey: SHOW_AUTHOR_AVATAR) == nil {
            userDefaults.set(false, forKey: SHOW_AUTHOR_AVATAR)
        }
        if userDefaults.object(forKey: ALWAYS_SHOW_CHILD_COMMENT_COUNT) == nil {
            userDefaults.set(false, forKey: ALWAYS_SHOW_CHILD_COMMENT_COUNT)
        }
        if userDefaults.object(forKey: HIDE_THE_NUMBER_OF_VOTES_IN_COMMENTS) == nil {
            userDefaults.set(false, forKey: HIDE_THE_NUMBER_OF_VOTES_IN_COMMENTS)
        }
        if userDefaults.object(forKey: SHOW_FEWER_TOOLBAR_OPTIONS_THRESHOLD) == nil {
            userDefaults.set(5, forKey: SHOW_FEWER_TOOLBAR_OPTIONS_THRESHOLD)
        }
        if userDefaults.object(forKey: EMBEDDED_MEDIA_TYPE) == nil {
            userDefaults.set(1, forKey: EMBEDDED_MEDIA_TYPE)
        }
        
        showTopLevelCommentsFirst = userDefaults.bool(forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST)
        showCommentDivider = userDefaults.bool(forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST)
        commentToolbarHiddenByDefault = userDefaults.bool(forKey: COMMENT_TOOLBAR_HIDDEN)
        clickToShowHideCommentToolbar = userDefaults.bool(forKey: COMMENT_TOOLBAR_HIDE_ON_CLICK)
        fullyCollapseComment = userDefaults.bool(forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST)
        showAuthorAvatar = userDefaults.bool(forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST)
        alwaysShowNumberOfChildComments = userDefaults.bool(forKey: SHOW_TOP_LEVEL_COMMENTS_FIRST)
        hideNumberOfVotes = userDefaults.bool(forKey: HIDE_THE_NUMBER_OF_VOTES_IN_COMMENTS)
        showFewerToolbarOptionsStartingFromLevel = userDefaults.integer(forKey: SHOW_FEWER_TOOLBAR_OPTIONS_THRESHOLD)
        embeddedMediaType = userDefaults.integer(forKey: EMBEDDED_MEDIA_TYPE)
            
        $showTopLevelCommentsFirst
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.SHOW_TOP_LEVEL_COMMENTS_FIRST ?? "")
            }
            .store(in: &cancellables)
        
        $showCommentDivider
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.SHOW_COMMENT_DIVIDER ?? "")
            }
            .store(in: &cancellables)
        
        $commentToolbarHiddenByDefault
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.COMMENT_TOOLBAR_HIDDEN ?? "")
            }
            .store(in: &cancellables)
        
        $clickToShowHideCommentToolbar
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.COMMENT_TOOLBAR_HIDE_ON_CLICK ?? "")
            }
            .store(in: &cancellables)
        
        $fullyCollapseComment
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.FULLY_COLLAPSE_COMMENT ?? "")
            }
            .store(in: &cancellables)
        
        $showAuthorAvatar
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.SHOW_AUTHOR_AVATAR ?? "")
            }
            .store(in: &cancellables)
        
        $alwaysShowNumberOfChildComments
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.SHOW_TOP_LEVEL_COMMENTS_FIRST ?? "")
            }
            .store(in: &cancellables)
        
        $hideNumberOfVotes
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.HIDE_THE_NUMBER_OF_VOTES_IN_COMMENTS ?? "")
            }
            .store(in: &cancellables)
        
        $showFewerToolbarOptionsStartingFromLevel
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.SHOW_FEWER_TOOLBAR_OPTIONS_THRESHOLD ?? "")
            }
            .store(in: &cancellables)
        
        $embeddedMediaType
            .sink { [weak self] newValue in
                self?.saveInterfaceSettings(setting: newValue, forKey: self?.EMBEDDED_MEDIA_TYPE ?? "")
            }
            .store(in: &cancellables)
        }
        
        // MARK: - Methods
        func saveInterfaceSettings<T>(setting: T, forKey key: String) {
            userDefaults.set(setting, forKey: key)
        }
        
    }
